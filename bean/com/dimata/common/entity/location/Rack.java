/*
 * Rack.java
 *
 * Created on April 25, 2006, 5:08 PM
 */

package com.dimata.common.entity.location;

/* package java */
import java.util.Date;
import java.io.*;

/* package qdep */
import com.dimata.qdep.entity.*;

public class Rack extends Entity implements Serializable {
    
    private String rackCode = "";
    private String rackName = "";
    private String rackDescription = "";
    
    /**
     * Holds value of property locationId.
     */
    private long locationId = 0;    
    
    
    public String getRackName(){
        return rackName;
    }
    
    public void setRackName(String rackName){
        if ( rackName == null ) {
            this.rackName = "";
        }
        this.rackName = rackName;
    }
    
    public String getRackCode(){
        return rackCode;
    }
    
    public void setRackCode(String rackCode){
        this.rackCode = rackCode;
    }
    
    public String getRackDescription(){
        return rackDescription;
    }
    
    public void setRackDescription(String rackDescription){
        if ( rackDescription == null ) {
            this.rackDescription = "";
        }
        this.rackDescription = rackDescription;
    } 
    
    /**
     * Getter for property locationId.
     * @return Value of property locationId.
     */
    public long getLocationId() {
        return this.locationId;
    }
    
    /**
     * Setter for property locationId.
     * @param locationId New value of property locationId.
     */
    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }
    
}
