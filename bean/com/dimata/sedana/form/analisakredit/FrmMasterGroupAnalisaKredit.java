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
import com.dimata.sedana.entity.analisakredit.MasterGroupAnalisaKredit;
import javax.servlet.http.HttpServletRequest;

public class FrmMasterGroupAnalisaKredit extends FRMHandler implements I_FRMInterface, I_FRMType {

	private MasterGroupAnalisaKredit entMasterGroupAnalisaKredit;
	public static final String FRM_NAME_MASTERGROUPANALISAKREDIT = "FRM_NAME_MASTERGROUPANALISAKREDIT";
	public static final int FRM_FIELD_MASTER_GROUP_ID = 0;
	public static final int FRM_FIELD_GROUPID = 1;
	public static final int FRM_FIELD_GROUPDESC = 2;
	public static final int FRM_FIELD_GROUPBOBOT = 3;
	public static final int FRM_FIELD_GROUPMIN = 4;
	public static final int FRM_FIELD_GROUPMAX = 5;
	public static final int FRM_FIELD_CREATEDAT = 6;
	public static final int FRM_FIELD_UPDATEDAT = 7;

	public static String[] fieldNames = {
		"FRM_FIELD_MASTER_GROUP_ID",
		"FRM_FIELD_GROUPID",
		"FRM_FIELD_GROUPDESC",
		"FRM_FIELD_GROUPBOBOT",
		"FRM_FIELD_GROUPMIN",
		"FRM_FIELD_GROUPMAX",
		"FRM_FIELD_CREATEDAT",
		"FRM_FIELD_UPDATEDAT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT,
		TYPE_DATE,
		TYPE_DATE
	};

	public FrmMasterGroupAnalisaKredit() {
	}

	public FrmMasterGroupAnalisaKredit(MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) {
		this.entMasterGroupAnalisaKredit = entMasterGroupAnalisaKredit;
	}

	public FrmMasterGroupAnalisaKredit(HttpServletRequest request, MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) {
		super(new FrmMasterGroupAnalisaKredit(entMasterGroupAnalisaKredit), request);
		this.entMasterGroupAnalisaKredit = entMasterGroupAnalisaKredit;
	}

	public String getFormName() {
		return FRM_NAME_MASTERGROUPANALISAKREDIT;
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

	public MasterGroupAnalisaKredit getEntityObject() {
		return entMasterGroupAnalisaKredit;
	}

	public void requestEntityObject(MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) {
		try {
			this.requestParam();
			entMasterGroupAnalisaKredit.setGroupId(getString(FRM_FIELD_GROUPID));
			entMasterGroupAnalisaKredit.setGroupDesc(getString(FRM_FIELD_GROUPDESC));
			entMasterGroupAnalisaKredit.setGroupBobot(getInt(FRM_FIELD_GROUPBOBOT));
			entMasterGroupAnalisaKredit.setGroupMin(getInt(FRM_FIELD_GROUPMIN));
			entMasterGroupAnalisaKredit.setGroupMax(getInt(FRM_FIELD_GROUPMAX));
			entMasterGroupAnalisaKredit.setCreatedAt(getDate(FRM_FIELD_CREATEDAT));
			entMasterGroupAnalisaKredit.setUpdatedAt(getDate(FRM_FIELD_UPDATEDAT));
		} catch (Exception e) {
			System.out.println("Error on requestEntityObject : " + e.toString());
		}
	}

}
