/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.kredit;

/**
 *
 * @author WiraDharma
 */
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.kredit.DokumenPinjaman;
import javax.servlet.http.HttpServletRequest;

public class FrmDokumenPinjaman extends FRMHandler implements I_FRMInterface, I_FRMType {

    private DokumenPinjaman entDokumenPinjaman;
    public static final String FRM_NAME_DOKUMENPINJAMAN = "FRM_NAME_DOKUMENPINJAMAN";
    public static final int FRM_FIELD_DOKUMEN_ID = 0;
    public static final int FRM_FIELD_PINJAMAN_ID = 1;
    public static final int FRM_FIELD_NAMA_DOKUMEN = 2;
    public static final int FRM_FIELD_NAMA_FILE = 3;
    public static final int FRM_FIELD_DESKRIPSI = 4;

    public static String[] fieldNames = {
        "FRM_FIELD_DOKUMEN_ID",
        "FRM_FIELD_PINJAMAN_ID",
        "FRM_FIELD_NAMA_DOKUMEN",
        "FRM_FIELD_NAMA_FILE",
        "FRM_FIELD_DESKRIPSI"
    };

    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public FrmDokumenPinjaman() {
    }

    public FrmDokumenPinjaman(DokumenPinjaman entDokumenPinjaman) {
        this.entDokumenPinjaman = entDokumenPinjaman;
    }

    public FrmDokumenPinjaman(HttpServletRequest request, DokumenPinjaman entDokumenPinjaman) {
        super(new FrmDokumenPinjaman(entDokumenPinjaman), request);
        this.entDokumenPinjaman = entDokumenPinjaman;
    }

    public String getFormName() {
        return FRM_NAME_DOKUMENPINJAMAN;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public DokumenPinjaman getEntityObject() {
        return entDokumenPinjaman;
    }

    public void requestEntityObject(DokumenPinjaman entDokumenPinjaman) {
        try {
            this.requestParam();
            entDokumenPinjaman.setPinjamanId(getLong(FRM_FIELD_PINJAMAN_ID));
            entDokumenPinjaman.setNamaDokumen(getString(FRM_FIELD_NAMA_DOKUMEN));
            entDokumenPinjaman.setNamaFile(getString(FRM_FIELD_NAMA_FILE));
            entDokumenPinjaman.setDeskripsi(getString(FRM_FIELD_DESKRIPSI));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
