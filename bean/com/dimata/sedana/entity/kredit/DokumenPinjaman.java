/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

/**
 *
 * @author WiraDharma
 */
import com.dimata.qdep.entity.Entity;

public class DokumenPinjaman extends Entity {

private long pinjamanId = 0;
private String namaDokumen = "";
private String namaFile = "";
private String deskripsi = "";

public long getPinjamanId(){
return pinjamanId;
}

public void setPinjamanId(long pinjamanId){
this.pinjamanId = pinjamanId;
}

public String getNamaDokumen(){
return namaDokumen;
}

public void setNamaDokumen(String namaDokumen){
this.namaDokumen = namaDokumen;
}

public String getNamaFile(){
return namaFile;
}

public void setNamaFile(String namaFile){
this.namaFile = namaFile;
}

public String getDeskripsi(){
return deskripsi;
}

public void setDeskripsi(String deskripsi){
this.deskripsi = deskripsi;
}

}