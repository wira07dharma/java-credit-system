/*
 * ObjSynchDeserializer.java
 *
 * Created on December 23, 2001, 10:27 AM
 * provide API for put and get files from storage devices
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
import com.dimata.services.DSJ_SvcParam;


import com.enterprisedt.net.ftp.FTPException;
import com.enterprisedt.net.ftp.FTPClient;
import com.enterprisedt.net.ftp.FTPTransferType;
import com.enterprisedt.net.ftp.FTPConnectMode;
import java.io.IOException;

/**
 *
 * @author  ktanjana
 * @version
 */
public class ObjSynchDevAPI implements Serializable {
    public static final String FTP_MODE_BINARY = "BINARY";
    public static final String FTP_MODE_ASCII  = "ASCII";
    public static final String FTP_CONN_MODE_PASIV = "PASIV";
    public static final String FTP_CONN_MODE_ACTIV  = "ACTIV";
    
    public static final String LOCAL_PATH_DELIM = System.getProperty("file.separator");
    
    public boolean running=true;
    
    public ObjSynchNode objSynch = null;
    
    public String LocalOutDirURL="";
    public String LocalInDirURL="";
    public String LocalScheFlagFolder = "";
    
    public String LocalObjectSubFolder="";
    public String LocalStatusSubFolder="";
    
    public String SchFlagBoff = "";
    public String SchFlagOnline ="";
    
    public FTPClient ftp = null;
    public String RemoteHost ="";
    public int RemotePort =21;
    public String RemoteUser ="";
    public String RemotePassword ="";
    public String RemoteOutDirURL="";
    public String RemoteInDirURL="";
    public String RemoteObjectSubFolder="";
    public String RemoteStatusSubFolder="";
    public String RemoteScheFlagFolder = "";
    public String RemotePathDelim=LOCAL_PATH_DELIM;
    
    public String FTPMode      = "BINARY";//args[5];
    public String FTPConnMode  = "PASV";//args[6];
    
    
    /** Creates new ObjSynchDeserializer */
    public ObjSynchDevAPI(ObjSynchNode objSynch ) {
        this.objSynch =  objSynch;
        LocalOutDirURL=this.objSynch.LocalOutDirURL ;
        LocalInDirURL=this.objSynch.LocalInDirURL;
        LocalScheFlagFolder = this.objSynch.LocalScheFlagFolder ;
        
        LocalObjectSubFolder=this.objSynch.LocalObjectSubFolder ;
        LocalStatusSubFolder=this.objSynch.LocalStatusSubFolder;
        
        SchFlagBoff = this.objSynch.SchFlagLocal;
        SchFlagOnline =this.objSynch.SchFlagRemote;
        
        RemoteHost =this.objSynch.RemoteHost;
        RemotePort =this.objSynch.RemotePort;
        RemoteUser =this.objSynch.RemoteUser;
        RemotePassword =this.objSynch.RemotePassword;
        RemoteOutDirURL=this.objSynch.RemoteOutDirURL;
        RemoteInDirURL=this.objSynch.RemoteInDirURL;
        RemoteObjectSubFolder=this.objSynch.RemoteObjectSubFolder;
        RemoteStatusSubFolder=this.objSynch.RemoteStatusSubFolder;
        RemoteScheFlagFolder = this.objSynch.RemoteScheFlagFolder;
        RemotePathDelim=LOCAL_PATH_DELIM;// set remote path same as local path//this.objSynch.RemotePathDelim;
        
        FTPMode      = this.objSynch.FTPMode;//args[5];
        FTPConnMode  = this.objSynch.FTPConnMode;//args[6];
    }
    
    public void putAllObject(String targetPath, boolean deleteLocalFile){
        try{
            String dirURL  = LocalOutDirURL + LOCAL_PATH_DELIM + this.objSynch.getLocalNodeName()
            + LOCAL_PATH_DELIM + this.objSynch.LocalObjectSubFolder ;
            
            Vector fileslist =  getFileList(dirURL, this.objSynch.TARGET_FILENAME_PREF_OBJECT);
            
            if( (fileslist == null) || (fileslist.size()<1)){
                putAllObjectTargetInStatus(targetPath, deleteLocalFile); // if there are a rest of status
                return;
            }
            
            String targetDir = targetPath+RemotePathDelim+this.objSynch.getLocalNodeName()+
            RemotePathDelim + RemoteObjectSubFolder;
            
            if(!DSJ_ObjSynch.createPath(targetDir))
                return;

            for(int i = 0; i < fileslist.size(); i++) {
                try{
                    java.io.File file = (java.io.File) fileslist.get(i);
                    if( (DSJ_ObjSynch.copyFile(
                            file.getAbsolutePath()+LOCAL_PATH_DELIM+file.getName(),
                            targetDir +RemotePathDelim+file.getName() )==DSJ_ClassMsg.OK) &&
                    deleteLocalFile){
                        file.delete();
                    }
                } catch(Exception exc){
                    System.out.println(" Exception in putAllObject "+exc);
                }
            }
            
            putAllObjectTargetInStatus(targetPath, deleteLocalFile);
            
        } catch(Exception exc){
            System.out.println(" Exception in putAllObject "+exc);
        }
    }
    
    public void putAllObjectTargetInStatus(String targetPath, boolean deleteLocalFile){
        try{
            Vector oNd = this.objSynch.getOtherNodesNames();
            if(oNd!=null){
               // String objDirURL  = LocalOutDirURL + LOCAL_PATH_DELIM + this.objSynch.getLocalNodeName()
               // + LOCAL_PATH_DELIM + this.objSynch.LocalObjectSubFolder ;
                
                for(int idx=0; idx< oNd.size();idx++){
                    
                    String dirURL= this.objSynch.LocalOutDirURL+ LOCAL_PATH_DELIM + this.objSynch.getLocalNodeName()
                    + LOCAL_PATH_DELIM + this.objSynch.LocalStatusSubFolder +  LOCAL_PATH_DELIM +
                    oNd.get(idx);
                    
                    Vector fileslist =  getFileList(dirURL, this.objSynch.TARGET_FILENAME_PREF_OBJECT);
                    
                    if( (fileslist == null) || (fileslist.size()<1))
                        return;
                    
                    String targetDir = RemoteInDirURL+LOCAL_PATH_DELIM+this.objSynch.getLocalNodeName()+
                    LOCAL_PATH_DELIM + RemoteStatusSubFolder + LOCAL_PATH_DELIM + oNd.get(idx) ;
                    
                    if(!DSJ_ObjSynch.createPath(targetDir))
                        return;


                    for(int i = 0; i < fileslist.size(); i++) {
                        try{
                            java.io.File file = (java.io.File) fileslist.get(i);
                            if( (DSJ_ObjSynch.copyFile(
                            file.getAbsolutePath()+LOCAL_PATH_DELIM+file.getName(),
                            targetDir +RemotePathDelim+file.getName() )==DSJ_ClassMsg.OK) &&
                            deleteLocalFile)
                                file.delete();
                        } catch(Exception exc){
                            System.out.println(" Exception in putAllObjectTargetInStatus "+exc);
                        }
                    }
                }
            }
        } catch(Exception exc){
            System.out.println(" Exception in putAllObjectTargetInStatus "+exc);
        }
    }
    
    private Vector getFileList( String dirURL, String beginName){
        try{
            java.io.File fl = new java.io.File(dirURL); // set in directory
            
            DSJ_FilenameFilter ff = new DSJ_FilenameFilter();
            ff.setFileNameStart(beginName);
            
            java.io.File[] fileslist = fl.listFiles(ff);
            
            if(fileslist != null) {
                Vector vctList = new Vector(1,1);
                for(int i = 0; i < fileslist.length; i++) {
                    java.io.File f = fileslist[i];
                    vctList.add(f);
                }
                return vctList;
            }
        } catch(Exception exc){
            System.out.println(" Exception in refreshVectorObjIn "+exc);
        }
        return null;
    }
    
    /*
    public void getStatus(String remoteFile, boolean deleteRemoteFile){
    }
     **/
    
    public void getAllStatus(boolean deleteRemoteFile){
        try{
            
            String localDir  = this.LocalInDirURL + LOCAL_PATH_DELIM +
            this.objSynch.getLocalNodeName() + LOCAL_PATH_DELIM +
            this.LocalStatusSubFolder;
            
            String remoteDir = RemoteOutDirURL+RemotePathDelim+RemoteStatusSubFolder;
            ftp.chdir(remoteDir);
            
            Vector fileslist =  getRemoteFileNameDir();
            
            if( (fileslist == null) || (fileslist.size()<1))
                return;
            
            for(int i = 0; i < fileslist.size(); i++) {
                try{
                    String fName = (String) fileslist.get(i);
                    if( (getFile(fName, localDir+LOCAL_PATH_DELIM+fName)==DSJ_ClassMsg.OK) &&
                    deleteRemoteFile)
                        ftp.delete(fName);
                }catch (Exception exc){
                    System.out.println(" Exception in refreshVectorObjIn "+exc);
                }
            }
        } catch(Exception exc){
            System.out.println(" Exception in refreshVectorObjIn "+exc);
        }
        
        
    }
    
    /*
    private void getObject(String remoteFile, boolean deleteRemoteFile){
    }
     */
    public void getAllObject(String sourcePath, boolean deleteRemoteDataFile, boolean deleteRemoteStatusFile){
        try{
            Vector nodes = this.objSynch.getOtherNodesNames();
            
            if(nodes!=null){
                for(int idx=0;idx<nodes.size();idx++){
                    
                    String localDir  = this.LocalInDirURL + LOCAL_PATH_DELIM +
                    this.objSynch.getOtherNodeName(idx) + LOCAL_PATH_DELIM +
                    this.LocalObjectSubFolder;
                    
                    String remoteObjDir = RemoteOutDirURL+RemotePathDelim+
                    this.objSynch.getOtherNodeName(idx)+RemotePathDelim+
                    RemoteObjectSubFolder;
                    
                    String remoteStatusDir = RemoteOutDirURL+RemotePathDelim+
                    this.objSynch.getOtherNodeName(idx)+RemotePathDelim+
                    RemoteStatusSubFolder + RemotePathDelim + this.objSynch.getLocalNodeName();

                    ftp.chdir(remoteStatusDir); // get status files  as list of files data to be got from data pool
                    Vector fileslist =  getRemoteFileNameDir();
                    
                    if( (fileslist == null) || (fileslist.size()<1))
                        return;
                    
                    for(int i = 0; i < fileslist.size(); i++) {
                        try{
                            String fName = (String) fileslist.get(i);
                            // get the data file
                            //ftp.chdir(remoteObjDir);
                            String remoteObjFName = remoteObjDir+RemotePathDelim+fName;
                            int getFile = getFile(remoteObjFName, localDir+LOCAL_PATH_DELIM+fName);

                            if(getFile==DSJ_ClassMsg.OK){
                               if(deleteRemoteDataFile){
                                       ftp.delete(remoteObjFName);
                               }

                               if(deleteRemoteStatusFile) {
                                    //ftp.chdir(remoteStatusDir);
                                    String remoteStFName = remoteStatusDir+RemotePathDelim+fName;
                                    ftp.delete(remoteStFName);
                               }
                            }
                        }catch (Exception exc){
                            System.out.println(" Exception in refreshVectorObjIn "+exc);
                        }
                    }
                }
            }
        } catch(Exception exc){
            System.out.println(" Exception in refreshVectorObjIn "+exc);
        }
        
    }
    
    
    public int putBOffSchFlag(){
        try{
            ftp.chdir(RemoteScheFlagFolder);
            this.putFile(LocalScheFlagFolder+ LOCAL_PATH_DELIM+SchFlagBoff, SchFlagBoff);
            return DSJ_ClassMsg.OK;
        } catch (Exception exc){
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    public int getOnlineSchFlag(){
        try{
            ftp.chdir(RemoteScheFlagFolder);
            this.getFile(SchFlagOnline, LocalScheFlagFolder+ LOCAL_PATH_DELIM+SchFlagOnline);
            return DSJ_ClassMsg.OK;
        } catch (Exception exc){
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    /*
    private void putFile(String localDir, String localFile, String remoteDir, String remoteFile){
    }
     */
    
    private int putFile(String localPath, String remoteDir, String remoteFile){
        int iErrCode = DSJ_ClassMsg.ERR_PROCESS_FAIL;
        try{
            ftp.chdir(remoteDir);
            ftp.put(localPath, remoteFile);
            iErrCode = DSJ_ClassMsg.OK;
        }catch(Exception exc){
        }
        return iErrCode;
    }
    
    private int putFile(String localPath, String remoteFile){
        int iErrCode = DSJ_ClassMsg.ERR_PROCESS_FAIL;
        try{
            ftp.put(localPath, remoteFile);
            iErrCode = DSJ_ClassMsg.OK;
        }catch(Exception exc){
            System.out.println(" ObjSynchFTPAPI >> put File >>"+exc);
        }
        return iErrCode;
    }
    
    
    public  Vector getRemoteFileNameDir(){
        Vector fNames= new Vector();
        try{
            String[] listings = ftp.dir(".", false);
            for (int i = 0; i < listings.length; i++)
                fNames.add(listings[i]);
        }catch (Exception exc){
            System.out.println(" >> getRemoteFileNameDir  "+exc);
        }
        return fNames;
    }
    
    public int getFile(String remoteFile, String localPath){
        int iErrCode = DSJ_ClassMsg.ERR_PROCESS_FAIL;
        try{
            byte[] buf = ftp.get(remoteFile);            
            FileOutputStream file = new FileOutputStream(localPath);
            file.write(buf);
            iErrCode = DSJ_ClassMsg.OK;
        }catch(Exception exc){
            System.out.println(">>> getFile RMT = "+ remoteFile +  " LOcal = "+ localPath +"\n"  + exc);
        }
        return iErrCode;
    }
    
    
    public void connectFTP(){
        try{
            // connect and test supplying port no.
            ftp = new FTPClient(this.RemoteHost, this.RemotePort);
            ftp.login(this.RemoteUser, this.RemotePassword);
            ftp.quit();
            
            // connect again
            ftp = new FTPClient(this.RemoteHost);
            
            // switch on debug of responses
            ftp.debugResponses(true);
            
            ftp.login(this.RemoteUser, this.RemotePassword);
            
            // binary or ASCII transfer
            if (FTP_MODE_BINARY.equalsIgnoreCase(this.FTPMode)) {
                ftp.setType(FTPTransferType.BINARY);
            }
            else if (FTP_MODE_ASCII.equalsIgnoreCase(this.FTPMode)) {
                ftp.setType(FTPTransferType.ASCII);
            }
            else {
                System.out.println("Unknown transfer type: " + this.FTPMode+ " set binary");
                ftp.setType(FTPTransferType.BINARY);
            }
            
            // PASV or active?
            if (FTP_CONN_MODE_PASIV.equalsIgnoreCase(this.FTPConnMode)) {
                ftp.setConnectMode(FTPConnectMode.PASV);
            }
            else if (FTP_CONN_MODE_ACTIV.equalsIgnoreCase(this.FTPConnMode)) {
                ftp.setConnectMode(FTPConnectMode.ACTIVE);
            }
            else {
                System.out.println("Unknown connect mode: " + this.FTPConnMode+ "  set pasiv");
                ftp.setConnectMode(FTPConnectMode.PASV);
            }
            
            System.out.println(" >>> connectFTP OK");
        } catch (Exception exc){
            System.out.println(" >>> connectFTP "+ exc);
        }
    }
    
    public boolean testConnectFTP(){
        try{
            // connect and test supplying port no.
            ftp = new FTPClient(this.RemoteHost, this.RemotePort);
            ftp.login(this.RemoteUser, this.RemotePassword);
            ftp.quit();
            
            // connect again
            ftp = new FTPClient(this.RemoteHost);
            
            // switch on debug of responses
            ftp.debugResponses(true);
            
            ftp.login(this.RemoteUser, this.RemotePassword);
            
            // binary or ASCII transfer
            if (FTP_MODE_BINARY.equalsIgnoreCase(this.FTPMode)) {
                ftp.setType(FTPTransferType.BINARY);
            }
            else if (FTP_MODE_ASCII.equalsIgnoreCase(this.FTPMode)) {
                ftp.setType(FTPTransferType.ASCII);
            }
            else {
                System.out.println("Unknown transfer type: " + this.FTPMode+ " set binary");
                ftp.setType(FTPTransferType.BINARY);
            }
            
            // PASV or active?
            if (FTP_CONN_MODE_PASIV.equalsIgnoreCase(this.FTPConnMode)) {
                ftp.setConnectMode(FTPConnectMode.PASV);
            }
            else if (FTP_CONN_MODE_ACTIV.equalsIgnoreCase(this.FTPConnMode)) {
                ftp.setConnectMode(FTPConnectMode.ACTIVE);
            }
            else {
                System.out.println("Unknown connect mode: " + this.FTPConnMode+ "  set pasiv");
                ftp.setConnectMode(FTPConnectMode.PASV);
            }
            
            System.out.println(" >>> connectFTP OK");
            return true;
            
        } catch (Exception exc){
            System.out.println(" >>> connectFTP "+ exc);
            return false;
        }
    }
    
    
    
}
