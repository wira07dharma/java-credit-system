package com.dimata.sedana.form.masterdata;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktuFormula;

/*
Description : Controll JangkaWaktuFormula
Date : Wed Jan 08 2020
Author : ASUS
 */
public class CtrlJangkaWaktuFormula extends Control implements I_Language {

	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;
	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};
	private int start;
	private long oidRes;
	private String msgString;
	private JangkaWaktuFormula entJangkaWaktuFormula;
	private PstJangkaWaktuFormula pstJangkaWaktuFormula;
	private FrmJangkaWaktuFormula frmJangkaWaktuFormula;
	int language = LANGUAGE_DEFAULT;

	public CtrlJangkaWaktuFormula(HttpServletRequest request) {
		oidRes = 0;
		msgString = "";
		entJangkaWaktuFormula = new JangkaWaktuFormula();
		try {
			pstJangkaWaktuFormula = new PstJangkaWaktuFormula(0);
		} catch (Exception e) {;
		}
		frmJangkaWaktuFormula = new FrmJangkaWaktuFormula(request, entJangkaWaktuFormula);
	}

	private String getSystemMessage(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				this.frmJangkaWaktuFormula.addError(frmJangkaWaktuFormula.FRM_FIELD_JANGKA_WAKTU_FORMULA_ID, resultText[language][RSLT_EST_CODE_EXIST]);
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR];
		}
	}

	private int getControlMsgId(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage() {
		return language;
	}

	public void setLanguage(int language) {
		this.language = language;
	}

	public JangkaWaktuFormula getJangkaWaktuFormula() {
		return entJangkaWaktuFormula;
	}

	public FrmJangkaWaktuFormula getForm() {
		return frmJangkaWaktuFormula;
	}

	public String getMessage() {
		return msgString;
	}

	public int getStart() {
		return start;
	}

	public long getOidRes(){
		return this.oidRes;
	}
	
	public int action(int cmd, long oidJangkaWaktuFormula, long userId, String userName) {
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch (cmd) {
			case Command.ADD:
				break;

			case Command.SAVE:
				if (oidJangkaWaktuFormula != 0) {
					try {
						entJangkaWaktuFormula = PstJangkaWaktuFormula.fetchExc(oidJangkaWaktuFormula);
					} catch (Exception exc) {
					}
				}

				frmJangkaWaktuFormula.requestEntityObject(entJangkaWaktuFormula);

				if (frmJangkaWaktuFormula.errorSize() > 0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE;
				}

//				String whereClause = PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + "=" + entJangkaWaktuFormula.getJangkaWaktuId() 
//						+ " AND " + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_TRANSACTION_TYPE] + "=" + entJangkaWaktuFormula.getTransType();
//				int isExisted = PstJangkaWaktuFormula.getCount(whereClause);
				int isExisted = 0;
				
				if (entJangkaWaktuFormula.getOID() == 0) {
					if(isExisted != 0){
						msgString = "Data sama ditemukan";
						return -1;
					}
					try {
						long oid = pstJangkaWaktuFormula.insertExc(this.entJangkaWaktuFormula);
						this.oidRes = oid;
						msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
						return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
					}

				} else {
					try {
						long oid = pstJangkaWaktuFormula.updateExc(this.entJangkaWaktuFormula);
						this.oidRes = oid;
						msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}

				}
				break;

			case Command.EDIT:
				if (oidJangkaWaktuFormula != 0) {
					try {
						entJangkaWaktuFormula = PstJangkaWaktuFormula.fetchExc(oidJangkaWaktuFormula);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK:
				if (oidJangkaWaktuFormula != 0) {
					try {
						entJangkaWaktuFormula = PstJangkaWaktuFormula.fetchExc(oidJangkaWaktuFormula);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE:
				if (oidJangkaWaktuFormula != 0) {
					try {
						long oid = PstJangkaWaktuFormula.deleteExc(oidJangkaWaktuFormula);
						this.oidRes = oid;
						if (oid != 0) {
							msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
							excCode = RSLT_OK;
						} else {
							msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			default:

		}
		return rsCode;
	}
}
