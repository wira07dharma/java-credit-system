package com.dimata.common.entity.search;

import java.util.*;

public class SrcContactList {    

    private Vector type = new Vector(1,1);
    private String code = "";
    private String name = "";
    private String address = "";
    private int orderBy = 0;

    /**
     * Holds value of property city.
     */
    private String city = "";
    
    /**
     * Holds value of property propince.
     */
    private String province = "";
    
    /**
     * Holds value of property country.
     */
    private String country = "";
    
    public Vector getType(){ return type; }

    public void setType(Vector type){ this.type = type; }

    public String getCode(){ return code; }

    public void setCode(String code){ this.code = code; }
    
    public String getName(){ return name; }

    public void setName(String name){ this.name = name; }
    
    public String getAddress(){ return address; }

    public void setAddress(String address){ this.address = address; }

    public int getOrderBy(){ return orderBy; }

    public void setOrderBy(int orderBy){ this.orderBy = orderBy; }
    
    /**
     * Getter for property city.
     * @return Value of property city.
     */
    public String getCity() {
        return this.city;
    }
    
    /**
     * Setter for property city.
     * @param city New value of property city.
     */
    public void setCity(String city) {
        this.city = city;
    }
    
    /**
     * Getter for property propince.
     * @return Value of property propince.
     */
    public String getProvince() {
        return this.province;
    }
    
    /**
     * Setter for property propince.
     * @param propince New value of property propince.
     */
    public void setProvince(String province) {
        this.province = province;
    }
    
    /**
     * Getter for property country.
     * @return Value of property country.
     */
    public String getCountry() {
        return this.country;
    }
    
    /**
     * Setter for property country.
     * @param country New value of property country.
     */
    public void setCountry(String country) {
        this.country = country;
    }
    
}
