package com.dimata.posbo.entity.search;
 
/* package java */ 
import java.util.*;

public class SrcPurchaseOrder
{ 


    private Vector prmstatus = new Vector();
    private String prmnumber = "";
    private String vendorname = "";
    private Date prmdatefrom = new Date();
    private Date prmdateto = new Date();
    private long location;
    private int statusdate;
    private int sortby;
    private int sortByType;
    private int locationType = -1;

    public Vector getPrmstatus(){ return prmstatus; } 

    public void setPrmstatus(Vector prmstatus){	this.prmstatus = prmstatus; } 

    public String getPrmnumber(){ return prmnumber; } 

    public void setPrmnumber(String prmnumber)
    { 
        if ( prmnumber == null ) 
        {
            prmnumber = ""; 
	} 
	this.prmnumber = prmnumber; 
    } 

    public String getVendorname(){ return vendorname; } 

    public void setVendorname(String vendorname)
    { 
        if ( vendorname == null ) 
        {
            vendorname = ""; 
	} 
	this.vendorname = vendorname; 
    } 

    public Date getPrmdatefrom(){ return prmdatefrom; } 

    public void setPrmdatefrom(Date prmdatefrom){ this.prmdatefrom = prmdatefrom; } 

    public Date getPrmdateto(){ return prmdateto; } 

    public void setPrmdateto(Date prmdateto){ this.prmdateto = prmdateto; } 

    public long getLocation(){ return location; }

    public void setLocation(long location){ this.location = location; }

    public int getStatusdate(){ return statusdate; } 

    public void setStatusdate(int statusdate){ 	this.statusdate = statusdate; } 

    public int getSortby(){ return sortby; } 

    public void setSortby(int sortby){ 	this.sortby = sortby; }

    public int getSortByType(){ return sortByType; }

    public void setSortByType(int sortByType){ this.sortByType = sortByType; }

    public int getLocationType(){ return locationType; }

    public void setLocationType(int locationType){ this.locationType = locationType; }
}
