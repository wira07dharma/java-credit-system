package com.dimata.posbo.entity.search;

/* package java */
import java.util.*;

public class SrcMaterial {

    private String matcode = "";
    private String matname = "";
    private long supplierId = 0;
    private long categoryId = 0;
    private long subCategoryId = 0;
    private int sortby;
    private String description = "";
    private long locationId;
    private int typeItem = -1;
    private long merkId;

    // new for colonias
    private String codeShip = "";
    private String codeCounter = "";
    private int jenisCode = 0;
    private int showImage = 0;
    private long oidCodeRange = 0;
    private String barCode = "";

    //new for update harga catalog
    private int showUpdateCatalog = 0;
    private Date dateFrom = new Date();
    private Date dateTo = new Date();

    //new for discount Qty
    private int  showDiscountQty = 0;

    //new for opsi stok 0
    private int showStokNol = 0;

    //new for opsi currencyTypeId
    private Vector currencyTypeId = new Vector(1,1);

    //new for opsi memberType
    private Vector memberTypeId = new Vector(1,1);

    //new for opsi printHpp
    private int showHpp = 0;

    //new for opsi currency
    private int showCurrency = 0;

    public long getOidCodeRange() {
        return oidCodeRange;
    }

    public void setOidCodeRange(long oidCodeRange) {
        this.oidCodeRange = oidCodeRange;
    }

    public int getShowImage() {
        return showImage;
    }

    public void setShowImage(int showImage) {
        this.showImage = showImage;
    }

    public int getJenisCode() {
        return jenisCode;
    }

    public void setJenisCode(int jenisCode) {
        this.jenisCode = jenisCode;
    }

    public String getCodeShip() {
        return codeShip;
    }

    public void setCodeShip(String codeShip) {
        this.codeShip = codeShip;
    }

    public String getCodeCounter() {
        return codeCounter;
    }

    public void setCodeCounter(String codeCounter) {
        this.codeCounter = codeCounter;
    }

    public String getMatcode() {
        return matcode;
    }

    public void setMatcode(String matcode) {
        if (matcode == null) {
            matcode = "";
        }
        this.matcode = matcode;
    }

    public String getMatname() {
        return matname;
    }

    public void setMatname(String matname) {
        if (matname == null) {
            matname = "";
        }
        this.matname = matname;
    }

    public long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(long supplierId) {
        this.supplierId = supplierId;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public long getSubCategoryId() {
        return subCategoryId;
    }

    public void setSubCategoryId(long subCategoryId) {
        this.subCategoryId = subCategoryId;
    }

    public int getSortby() {
        return sortby;
    }

    public void setSortby(int sortby) {
        this.sortby = sortby;
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

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    /** Getter for property typeItem.
     * @return Value of property typeItem.
     *
     */
    public int getTypeItem() {
        return this.typeItem;
    }

    /** Setter for property typeItem.
     * @param typeItem New value of property typeItem.
     *
     */
    public void setTypeItem(int typeItem) {
        this.typeItem = typeItem;
    }

    /** Getter for property merkId.
     * @return Value of property merkId.
     *
     */
    public long getMerkId() {
        return this.merkId;
    }

    /** Setter for property merkId.
     * @param merkId New value of property merkId.
     *
     */
    public void setMerkId(long merkId) {
        this.merkId = merkId;
    }

    /**
     * @return the barCode
     */
    public String getBarCode() {
        return barCode;
    }

    /**
     * @param barCode the barCode to set
     */
    public void setBarCode(String barCode) {
        this.barCode = barCode;
    }

    /**
     * @return the showUpdateCatalog
     */
    public int getShowUpdateCatalog() {
        return showUpdateCatalog;
    }

    /**
     * @param showUpdateCatalog the showUpdateCatalog to set
     */
    public void setShowUpdateCatalog(int showUpdateCatalog) {
        this.showUpdateCatalog = showUpdateCatalog;
    }

    /**
     * @return the dateFrom
     */
    public Date getDateFrom() {
        return dateFrom;
    }

    /**
     * @param dateFrom the dateFrom to set
     */
    public void setDateFrom(Date dateFrom) {
        this.dateFrom = dateFrom;
    }

    /**
     * @return the dateTo
     */
    public Date getDateTo() {
        return dateTo;
    }

    /**
     * @param dateTo the dateTo to set
     */
    public void setDateTo(Date dateTo) {
        this.dateTo = dateTo;
    }

    /**
     * @return the showDiscountQty
     */
    public int getShowDiscountQty() {
        return showDiscountQty;
    }

    /**
     * @param showDiscountQty the showDiscountQty to set
     */
    public void setShowDiscountQty(int showDiscountQty) {
        this.showDiscountQty = showDiscountQty;
    }

    /**
     * @return the showStokNol
     */
    public int getShowStokNol() {
        return showStokNol;
    }

    /**
     * @param showStokNol the showStokNol to set
     */
    public void setShowStokNol(int showStokNol) {
        this.showStokNol = showStokNol;
    }

    /**
     * @return the currencyTypeId
     */
    public Vector getCurrencyTypeId() {
        return currencyTypeId;
    }

    /**
     * @param currencyTypeId the currencyTypeId to set
     */
    public void setCurrencyTypeId(Vector currencyTypeId) {
        this.currencyTypeId = currencyTypeId;
    }

    /**
     * @return the memberTypeId
     */
    public Vector getMemberTypeId() {
        return memberTypeId;
    }

    /**
     * @param memberTypeId the memberTypeId to set
     */
    public void setMemberTypeId(Vector memberTypeId) {
        this.memberTypeId = memberTypeId;
    }

    /**
     * @return the showHpp
     */
    public int getShowHpp() {
        return showHpp;
    }

    /**
     * @param showHpp the showHpp to set
     */
    public void setShowHpp(int showHpp) {
        this.showHpp = showHpp;
    }

    /**
     * @return the showCurrency
     */
    public int getShowCurrency() {
        return showCurrency;
    }

    /**
     * @param showCurrency the showCurrency to set
     */
    public void setShowCurrency(int showCurrency) {
        this.showCurrency = showCurrency;
    }


}
