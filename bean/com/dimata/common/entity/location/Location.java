
/* Created on 	:  [date] [time] AM/PM
 *
 * @author  	: karya
 * @version  	: 01
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...]
 * *****************************************************************
 */
package com.dimata.common.entity.location;

/* package java */
import java.io.*;

/* package qdep */
import com.dimata.qdep.entity.*;

public class Location extends Entity implements Serializable {

  private String name = "";
  private long contactId = 0;
  private String description = "";
  private String code = "";
  private String address = "";
  private String telephone = "";
  private String fax = "";
  private String person = "";
  private String email = "";
  private int type = 0;
  private long parentLocationId = 0;
  private String website = "";
  private long vendorId;
  private double servicePersen = 0.0;
  private double taxPersen = 0.0;
  private long departmentId = 0;
  private double serviceValue = 0.0;
  private double taxValue = 0.0;
  private double serviceValueUsd = 0.0;
  private double taxValueUsd = 0.0;
  private int reportGroup = 0;
  private int typeBase = 0;
  private int locIndex = 0;
  private long regencyId = 0;
  private int taxSvcDefault = 0;

  public int getLocIndex() {
    return locIndex;
  }

  public void setLocIndex(int locIndex) {
    this.locIndex = locIndex;
  }

  public int getTypeBase() {
    return typeBase;
  }

  public void setTypeBase(int typeBase) {
    this.typeBase = typeBase;
  }

  public double getServicePersen() {
    return servicePersen;
  }

  public void setServicePersen(double servicePersen) {
    this.servicePersen = servicePersen;
  }

  public double getTaxPersen() {
    return taxPersen;
  }

  public void setTaxPersen(double taxPersen) {
    this.taxPersen = taxPersen;
  }

  public long getDepartmentId() {
    return departmentId;
  }

  public void setDepartmentId(long departmentId) {
    this.departmentId = departmentId;
  }

  public double getServiceValue() {
    return serviceValue;
  }

  public void setServiceValue(double serviceValue) {
    this.serviceValue = serviceValue;
  }

  public double getTaxValue() {
    return taxValue;
  }

  public void setTaxValue(double taxValue) {
    this.taxValue = taxValue;
  }

  public double getServiceValueUsd() {
    return serviceValueUsd;
  }

  public void setServiceValueUsd(double serviceValueUsd) {
    this.serviceValueUsd = serviceValueUsd;
  }

  public double getTaxValueUsd() {
    return taxValueUsd;
  }

  public void setTaxValueUsd(double taxValueUsd) {
    this.taxValueUsd = taxValueUsd;
  }

  public int getReportGroup() {
    return reportGroup;
  }

  public void setReportGroup(int reportGroup) {
    this.reportGroup = reportGroup;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    if (name == null) {
      name = "";
    }
    this.name = name;
  }

  public long getContactId() {
    return contactId;
  }

  public void setContactId(long contactId) {
    this.contactId = contactId;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    if (description == null) {
      description = "";
    }
    this.description = description;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    if (code == null) {
      code = "";
    }
    this.code = code;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    if (address == null) {
      address = "";
    }
    this.address = address;
  }

  public String getTelephone() {
    return telephone;
  }

  public void setTelephone(String telephone) {
    if (telephone == null) {
      telephone = "";
    }
    this.telephone = telephone;
  }

  public String getFax() {
    return fax;
  }

  public void setFax(String fax) {
    if (fax == null) {
      fax = "";
    }
    this.fax = fax;
  }

  public String getPerson() {
    return person;
  }

  public void setPerson(String person) {
    if (person == null) {
      person = "";
    }
    this.person = person;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    if (email == null) {
      email = "";
    }
    this.email = email;
  }

  public int getType() {
    return type;
  }

  public void setType(int type) {
    this.type = type;
  }

  public long getParentLocationId() {
    return parentLocationId;
  }

  public void setParentLocationId(long parentLocationId) {
    this.parentLocationId = parentLocationId;
  }

  public String getWebsite() {
    return website;
  }

  public void setWebsite(String website) {
    if (website == null) {
      website = "";
    }
    this.website = website;
  }

  public long getVendorId() {
    return vendorId;
  }

  public void setVendorId(long vendorId) {
    this.vendorId = vendorId;
  }

  public String getPstClassName() {
    return "com.dimata.common.entity.location.PstLocation";
  }

	/**
	 * @return the regencyId
	 */
	public long getRegencyId() {
		return regencyId;
	}

	/**
	 * @param regencyId the regencyId to set
	 */
	public void setRegencyId(long regencyId) {
		this.regencyId = regencyId;
	}

    /**
     * @return the taxSvcDefault
     */
    public int getTaxSvcDefault() {
        return taxSvcDefault;
    }

    /**
     * @param taxSvcDefault the taxSvcDefault to set
     */
    public void setTaxSvcDefault(int taxSvcDefault) {
        this.taxSvcDefault = taxSvcDefault;
    }
  
  
}
