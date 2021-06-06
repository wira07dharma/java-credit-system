/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.analisakredit;

/**
 *
 * @author arise
 */
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;
import com.dimata.sedana.entity.analisakredit.MasterAnalisaKredit;
import javax.servlet.http.HttpServletRequest;

public class FrmMasterAnalisaKredit extends FRMHandler implements I_FRMInterface, I_FRMType {

	private MasterAnalisaKredit entMasterAnalisaKredit;
	public static final String FRM_NAME_MASTERANALISAKREDIT = "FRM_NAME_MASTERANALISAKREDIT";
	public static final int FRM_FIELD_MASTER_ANALISA_KREDIT_ID = 0;
	public static final int FRM_FIELD_GROUPID = 1;
	public static final int FRM_FIELD_ANALISAID = 2;
	public static final int FRM_FIELD_DESCRIPTION = 3;
	public static final int FRM_FIELD_CREATEDAT = 4;
	public static final int FRM_FIELD_UPDATEDAT = 5;

	public static String[] fieldNames = {
		"FRM_FIELD_MASTER_ANALISA_KREDIT_ID",
		"FRM_FIELD_GROUPID",
		"FRM_FIELD_ANALISAID",
		"FRM_FIELD_DESCRIPTION",
		"FRM_FIELD_CREATEDAT",
		"FRM_FIELD_UPDATEDAT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE
	};

	public FrmMasterAnalisaKredit() {
	}

	public FrmMasterAnalisaKredit(MasterAnalisaKredit entMasterAnalisaKredit) {
		this.entMasterAnalisaKredit = entMasterAnalisaKredit;
	}

	public FrmMasterAnalisaKredit(HttpServletRequest request, MasterAnalisaKredit entMasterAnalisaKredit) {
		super(new FrmMasterAnalisaKredit(entMasterAnalisaKredit), request);
		this.entMasterAnalisaKredit = entMasterAnalisaKredit;
	}

	public String getFormName() {
		return FRM_NAME_MASTERANALISAKREDIT;
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

	public MasterAnalisaKredit getEntityObject() {
		return entMasterAnalisaKredit;
	}

	public void requestEntityObject(MasterAnalisaKredit entMasterAnalisaKredit) {
		try {
			this.requestParam();
			entMasterAnalisaKredit.setGroupId(getLong(FRM_FIELD_GROUPID));
			entMasterAnalisaKredit.setAnalisaId(getString(FRM_FIELD_ANALISAID));
			entMasterAnalisaKredit.setDescription(getString(FRM_FIELD_DESCRIPTION));
			entMasterAnalisaKredit.setCreatedAt(getDate(FRM_FIELD_CREATEDAT));
			entMasterAnalisaKredit.setUpdatedAt(getDate(FRM_FIELD_UPDATEDAT));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
