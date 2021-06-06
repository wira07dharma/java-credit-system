/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.analisakredit;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditDetail;
import javax.servlet.http.HttpServletRequest;

public class FrmAnalisaKreditDetail extends FRMHandler implements I_FRMInterface, I_FRMType {

	private AnalisaKreditDetail entAnalisaKreditDetail;
	public static final String FRM_NAME_ANALISAKREDITDETAIL = "FRM_NAME_ANALISAKREDITDETAIL";
	public static final int FRM_FIELD_ANALISAKREDITDETAILID = 0;
	public static final int FRM_FIELD_ANALISAKREDITMAINID = 1;
	public static final int FRM_FIELD_MASTERANALISAKREDITID = 2;
	public static final int FRM_FIELD_NILAI = 3;
	public static final int FRM_FIELD_NOTES = 4;

	public static String[] fieldNames = {
		"FRM_FIELD_ANALISAKREDITDETAILID",
		"FRM_FIELD_ANALISAKREDITMAINID",
		"FRM_FIELD_MASTERANALISAKREDITID",
		"FRM_FIELD_NILAI",
		"FRM_FIELD_NOTES"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING
	};

	public FrmAnalisaKreditDetail() {
	}

	public FrmAnalisaKreditDetail(AnalisaKreditDetail entAnalisaKreditDetail) {
		this.entAnalisaKreditDetail = entAnalisaKreditDetail;
	}

	public FrmAnalisaKreditDetail(HttpServletRequest request, AnalisaKreditDetail entAnalisaKreditDetail) {
		super(new FrmAnalisaKreditDetail(entAnalisaKreditDetail), request);
		this.entAnalisaKreditDetail = entAnalisaKreditDetail;
	}

	public String getFormName() {
		return FRM_NAME_ANALISAKREDITDETAIL;
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

	public AnalisaKreditDetail getEntityObject() {
		return entAnalisaKreditDetail;
	}

	public void requestEntityObject(AnalisaKreditDetail entAnalisaKreditDetail) {
		try {
			this.requestParam();
			entAnalisaKreditDetail.setAnalisaKreditMainId(getLong(FRM_FIELD_ANALISAKREDITMAINID));
			entAnalisaKreditDetail.setMasterAnalisaKreditId(getLong(FRM_FIELD_MASTERANALISAKREDITID));
			entAnalisaKreditDetail.setNilai(getFloat(FRM_FIELD_NILAI));
			entAnalisaKreditDetail.setNotes(getString(FRM_FIELD_NOTES));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
