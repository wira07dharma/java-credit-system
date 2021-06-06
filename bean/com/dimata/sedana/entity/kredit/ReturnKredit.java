/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

/**
 *
 * @author Regen
 */
import com.dimata.qdep.entity.Entity;
import java.util.Date;

public class ReturnKredit extends Entity {

private String nomorReturn = "";
private long pinjamanId = 0;
private long transaksiId = 0;
private long cashBillMainId = 0;
private Date tanggalReturn = null;
private long locationTransaksi = 0;
private int status = 0;
private String catatan = "";
private int jenisReturn = 0;

public static final int STATUS_RETURN_DRAFT = 0;
public static final int DOCUMENT_STATUS_CANCELLED = 6;
public static final int DOCUMENT_STATUS_POSTED = 7;
public static final int STATUS_RETURN_RETURN = 11;

public static final String returnStatusKey[] = {"Draft", "Closed", "Posted", "Cancel"};
public static final String returnStatusValue[] = {"0", "11", "7", "6"};
  
public static final int JENIS_RETURN_CABUTAN = 0;
public static final int JENIS_RETURN_EXCHANGE = 1;

public static final String[] JENIS_RETURN_TITLE = {
  "Return",
  "Pembatalan"
};

public String getNomorReturn(){
return nomorReturn;
}

public void setNomorReturn(String nomorReturn){
this.nomorReturn = nomorReturn;
}

public long getPinjamanId(){
return pinjamanId;
}

public void setPinjamanId(long pinjamanId){
this.pinjamanId = pinjamanId;
}

public long getTransaksiId(){
return transaksiId;
}

public void setTransaksiId(long transaksiId){
this.transaksiId = transaksiId;
}

public long getCashBillMainId(){
return cashBillMainId;
}

public void setCashBillMainId(long cashBillMainId){
this.cashBillMainId = cashBillMainId;
}

public Date getTanggalReturn(){
return tanggalReturn;
}

public void setTanggalReturn(Date tanggalReturn){
this.tanggalReturn = tanggalReturn;
}

public long getLocationTransaksi(){
return locationTransaksi;
}

public void setLocationTransaksi(long locationTransaksi){
this.locationTransaksi = locationTransaksi;
}

public int getStatus(){
return status;
}

public void setStatus(int status){
this.status = status;
}

public String getCatatan(){
return catatan;
}

public void setCatatan(String catatan){
this.catatan = catatan;
}

    /**
     * @return the jenisReturn
     */
    public int getJenisReturn() {
        return jenisReturn;
    }

    /**
     * @param jenisReturn the jenisReturn to set
     */
    public void setJenisReturn(int jenisReturn) {
        this.jenisReturn = jenisReturn;
    }

}