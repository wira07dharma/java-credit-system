/*
 * SynchStatus.java
 *
 * Created on January 19, 2002, 5:06 PM
 */


package com.dimata.services.objsynchxnodes;
import java.io.*;
/**
 *
 * @author  ktanjana
 * @version 
 */
public class SynchStatus extends Object implements Serializable {
    public long seqIndex=0;
    public int status=-1;
    public String className = "";
    public long objectID = 0;
    
    /** Creates new SynchStatus */
    public SynchStatus() {
    }
    
    public SynchStatus(long seqIndex, int status, String className, long objectID ) {
        this.seqIndex=seqIndex;
        this.status=status;
        this.className = className;
        this.objectID = objectID ;
    }
}
