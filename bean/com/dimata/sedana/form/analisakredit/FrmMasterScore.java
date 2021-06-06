/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.analisakredit;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.analisakredit.MasterScore;
import javax.servlet.http.HttpServletRequest;

public class FrmMasterScore extends FRMHandler implements I_FRMInterface, I_FRMType {

	private MasterScore entMasterScore;
	public static final String FRM_NAME_MASTERSCORE = "FRM_NAME_MASTERSCORE";
	public static final int FRM_FIELD_MASTER_SCORE_OID = 0;
	public static final int FRM_FIELD_GROUP_ID = 1;
	public static final int FRM_FIELD_SCORE_MIN = 2;
	public static final int FRM_FIELD_SCORE_MAX = 3;
	public static final int FRM_FIELD_DESCRIPTION = 4;

	public static String[] fieldNames = {
		"FRM_FIELD_MASTER_SCORE_OID",
		"FRM_FIELD_GROUP_OID",
		"FRM_FIELD_SCORE_MIN",
		"FRM_FIELD_SCORE_MAX",
		"FRM_FIELD_DESCRIPTION"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING	
	};

	public FrmMasterScore() {
	}

	public FrmMasterScore(MasterScore entMasterScore) {
		this.entMasterScore = entMasterScore;
	}

	public FrmMasterScore(HttpServletRequest request, MasterScore entMasterScore) {
		super(new FrmMasterScore(entMasterScore), request);
		this.entMasterScore = entMasterScore;
	}

	public String getFormName() {
		return FRM_NAME_MASTERSCORE;
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

	public MasterScore getEntityObject() {
		return entMasterScore;
	}

	public void requestEntityObject(MasterScore entMasterScore) {
		try {
			this.requestParam();
			entMasterScore.setOID(getLong(FRM_FIELD_MASTER_SCORE_OID));
			entMasterScore.setScoreMin(getDouble(FRM_FIELD_SCORE_MIN));
			entMasterScore.setScoreMax(getDouble(FRM_FIELD_SCORE_MAX));
			entMasterScore.setDescription(getString(FRM_FIELD_DESCRIPTION));
			entMasterScore.setGroupId(getLong(FRM_FIELD_GROUP_ID)); 
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
