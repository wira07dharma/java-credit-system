/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.masterdata;

import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author arise
 */
public class FrmJangkaWaktuFormula extends FRMHandler implements I_FRMInterface, I_FRMType{

	private JangkaWaktuFormula entJangkaWaktuFormula;
	public static final String FRM_NAME_JANGKAWAKTUFORMULA = "FRM_NAME_JANGKAWAKTUFORMULA";
	public static final int FRM_FIELD_JANGKA_WAKTU_FORMULA_ID = 0;
	public static final int FRM_FIELD_JANGKA_WAKTU_ID = 1;
	public static final int FRM_FIELD_TRANSACTION_TYPE = 2;
	public static final int FRM_FIELD_FORMULA = 3;
        public static final int FRM_FIELD_CODE = 4;
        public static final int FRM_FIELD_COMP_NAME = 5;
        public static final int FRM_FIELD_IDX = 6;
        public static final int FRM_FIELD_PEMBULATAN = 7;
        public static final int FRM_FIELD_JENIS_KREDIT_ID = 8;
        public static final int FRM_FIELD_STATUS = 9;

	public static String[] fieldNames = {
		"FRM_FIELD_JANGKA_WAKTU_FORMULA_ID",
		"FRM_FIELD_JANGKA_WAKTU_ID",
		"FRM_FIELD_TRANSACTION_TYPE",
		"FRM_FIELD_FORMULA",
                "FRM_FIELD_CODE",
                "FRM_FIELD_COMP_NAME",
                "FRM_FIELD_IDX",
                "FRM_FIELD_PEMBULATAN",
                "FRM_FIELD_JENIS_KREDIT_ID",
                "FRM_FIELD_STATUS"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_INT
	};

	public FrmJangkaWaktuFormula() {
	}

	public FrmJangkaWaktuFormula(JangkaWaktuFormula entJangkaWaktuFormula) {
		this.entJangkaWaktuFormula = entJangkaWaktuFormula;
	}

	public FrmJangkaWaktuFormula(HttpServletRequest request, JangkaWaktuFormula entJangkaWaktuFormula) {
		super(new FrmJangkaWaktuFormula(entJangkaWaktuFormula), request);
		this.entJangkaWaktuFormula = entJangkaWaktuFormula;
	}

	public String getFormName() {
		return FRM_NAME_JANGKAWAKTUFORMULA;
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

	public JangkaWaktuFormula getEntityObject() {
		return entJangkaWaktuFormula;
	}

	public void requestEntityObject(JangkaWaktuFormula entJangkaWaktuFormula) {
		try {
			this.requestParam();
			entJangkaWaktuFormula.setOID(getLong(FRM_FIELD_JANGKA_WAKTU_FORMULA_ID));
			entJangkaWaktuFormula.setJangkaWaktuId(getLong(FRM_FIELD_JANGKA_WAKTU_ID));
			entJangkaWaktuFormula.setTransType(getInt(FRM_FIELD_TRANSACTION_TYPE));
			entJangkaWaktuFormula.setFormula(getString(FRM_FIELD_FORMULA));
                        entJangkaWaktuFormula.setCode(getString(FRM_FIELD_CODE));
                        entJangkaWaktuFormula.setCompName(getString(FRM_FIELD_COMP_NAME));
                        entJangkaWaktuFormula.setIdx(getInt(FRM_FIELD_IDX));
                        entJangkaWaktuFormula.setPembulatan(getInt(FRM_FIELD_PEMBULATAN));
                        entJangkaWaktuFormula.setJenisKreditId(getLong(FRM_FIELD_JENIS_KREDIT_ID));
                        entJangkaWaktuFormula.setStatus(getInt(FRM_FIELD_STATUS));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}
}
