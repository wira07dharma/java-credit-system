package com.dimata.posbo.entity.masterdata;
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

public class SubCategory extends Entity 
{
    private long categoryId;
    private String code = "";
    private String name = "";

    public long getCategoryId(){ return categoryId; }

    public void setCategoryId(long categoryId){ this.categoryId = categoryId; }

    public String getCode()
    { 
        return code; 
    } 

    public void setCode(String code)
    { 
	if ( code == null ) 
        {
            code = ""; 
	} 
	this.code = code; 
    } 

    public String getName()
    { 
	return name; 
    } 

    public void setName(String name)
    { 
	if ( name == null ) 
        {
            name = ""; 
	} 
	this.name = name; 
    }

}
