/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.analisakredit;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditMain;
import com.dimata.util.Formater;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

public class FrmAnalisaKreditMain extends FRMHandler implements I_FRMInterface, I_FRMType {

	private AnalisaKreditMain entAnalisaKreditMain;
	public static final String FRM_NAME_ANALISAKREDITMAIN = "FRM_NAME_ANALISAKREDITMAIN";
	public static final int FRM_FIELD_ANALISAKREDITMAINID = 0;
	public static final int FRM_FIELD_PINJAMANID = 1;
	public static final int FRM_FIELD_ANALISID = 2;
	public static final int FRM_FIELD_DIVISIONHEADID = 3;
	public static final int FRM_FIELD_MANAGERID = 4;
	public static final int FRM_FIELD_PENGHASILAN_PEMOHON = 5;
	public static final int FRM_FIELD_PENGELUARAN = 6;
	public static final int FRM_FIELD_SURPLUSANGSURAN = 7;
	public static final int FRM_FIELD_ANALISATGL = 8;
	public static final int FRM_FIELD_ANALISANOTE = 9;
	public static final int FRM_FIELD_ANALISANUMBER = 10;
	public static final int FRM_FIELD_LOCATIONID = 11;
	public static final int FRM_FIELD_PENGHASILAN_PENANGGUNG = 12;
	public static final int FRM_FIELD_PENGELUARAN_KONSUMSI = 13;
	public static final int FRM_FIELD_PENGELUARAN_LISTELPAM = 14;
	public static final int FRM_FIELD_PENGELUARAN_PENDIDIKAN = 15;
	public static final int FRM_FIELD_PENGELUARAN_SANDANG = 16;
	public static final int FRM_FIELD_PENGELUARAN_LAINNYA = 17;
	public static final int FRM_FIELD_ANALISA_STATUS = 18;

	public static String[] fieldNames = {
		"FRM_FIELD_ANALISAKREDITMAINID",
		"FRM_FIELD_PINJAMANID",
		"FRM_FIELD_ANALISID",
		"FRM_FIELD_DIVISIONHEADID",
		"FRM_FIELD_MANAGERID",
		"FRM_FIELD_PENGHASILAN_PEMOHON",
		"FRM_FIELD_PENGELUARAN",
		"FRM_FIELD_SURPLUSANGSURAN",
		"FRM_FIELD_ANALISATGL",
		"FRM_FIELD_ANALISANOTE",
		"FRM_FIELD_ANALISANUMBER",
		"FRM_FIELD_LOCATIONID",
		"FRM_FIELD_PENGHASILAN_PENANGGUNG",
		"FRM_FIELD_PENGELUARAN_KONSUMSI",
		"FRM_FIELD_PENGELUARAN_LISTELPAM",
		"FRM_FIELD_PENGELUARAN_PENDIDIKAN",
		"FRM_FIELD_PENGELUARAN_SANDANG",
		"FRM_FIELD_PENGELUARAN_LAINNYA",
		"FRM_FIELD_ANALISA_STATUS"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT
	};

	public FrmAnalisaKreditMain() {
	}

	public FrmAnalisaKreditMain(AnalisaKreditMain entAnalisaKreditMain) {
		this.entAnalisaKreditMain = entAnalisaKreditMain;
	}

	public FrmAnalisaKreditMain(HttpServletRequest request, AnalisaKreditMain entAnalisaKreditMain) {
		super(new FrmAnalisaKreditMain(entAnalisaKreditMain), request);
		this.entAnalisaKreditMain = entAnalisaKreditMain;
	}

	public String getFormName() {
		return FRM_NAME_ANALISAKREDITMAIN;
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

	public AnalisaKreditMain getEntityObject() {
		return entAnalisaKreditMain;
	}

	public void requestEntityObject(AnalisaKreditMain entAnalisaKreditMain) {
		try {
			this.requestParam();
			
			String tglAnalisa = this.getString(FRM_FIELD_ANALISATGL);
			Date analisa = Formater.formatDate(tglAnalisa, "yyyy-MM-dd");
			
			entAnalisaKreditMain.setPinjamanId(getLong(FRM_FIELD_PINJAMANID));
			entAnalisaKreditMain.setAnalisId(getLong(FRM_FIELD_ANALISID));
			entAnalisaKreditMain.setDivisionHeadId(getLong(FRM_FIELD_DIVISIONHEADID));
			entAnalisaKreditMain.setManagerId(getLong(FRM_FIELD_MANAGERID));
			entAnalisaKreditMain.setPenghasilanPemohon(getDouble(FRM_FIELD_PENGHASILAN_PEMOHON));
			entAnalisaKreditMain.setPengeluaran(getDouble(FRM_FIELD_PENGELUARAN));
			entAnalisaKreditMain.setSurplusAngsuran(getDouble(FRM_FIELD_SURPLUSANGSURAN));
			entAnalisaKreditMain.setAnalisaTgl(analisa);
			entAnalisaKreditMain.setAnalisaNote(getString(FRM_FIELD_ANALISANOTE));
			entAnalisaKreditMain.setAnalisaNumber(getString(FRM_FIELD_ANALISANUMBER));
			entAnalisaKreditMain.setLocationId(getLong(FRM_FIELD_LOCATIONID));
			entAnalisaKreditMain.setPenghasilanPenanggung(getDouble(FRM_FIELD_PENGHASILAN_PENANGGUNG));
			entAnalisaKreditMain.setPengeluaranKonsumsi(getDouble(FRM_FIELD_PENGELUARAN_KONSUMSI));
			entAnalisaKreditMain.setPengeluaranListelpam(getDouble(FRM_FIELD_PENGELUARAN_LISTELPAM));
			entAnalisaKreditMain.setPengeluaranPendidikan(getDouble(FRM_FIELD_PENGELUARAN_PENDIDIKAN));
			entAnalisaKreditMain.setPengeluaranSandang(getDouble(FRM_FIELD_PENGELUARAN_SANDANG));
			entAnalisaKreditMain.setPengeluaranLainnya(getDouble(FRM_FIELD_PENGELUARAN_LAINNYA)); 
			entAnalisaKreditMain.setAnalisaStatus(getInt(FRM_FIELD_ANALISA_STATUS)); 
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
