/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.analisakredit;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.sedana.entity.analisakredit.MasterScore;
import com.dimata.sedana.entity.analisakredit.PstMasterScore;

/*
Description : Controll MasterScore
Date : Tue Dec 24 2019
Author : ASUS
 */
public class CtrlMasterScore extends Control implements I_Language {

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
	private long groupOidRes;
	private String msgString;
	private MasterScore entMasterScore;
	private PstMasterScore pstMasterScore;
	private FrmMasterScore frmMasterScore;
	int language = LANGUAGE_DEFAULT;

	public CtrlMasterScore(HttpServletRequest request) {
		msgString = "";
		entMasterScore = new MasterScore();
		try {
			pstMasterScore = new PstMasterScore(0);
		} catch (Exception e) {;
		}
		frmMasterScore = new FrmMasterScore(request, entMasterScore);
	}

	private String getSystemMessage(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				this.frmMasterScore.addError(frmMasterScore.FRM_FIELD_MASTER_SCORE_OID, resultText[language][RSLT_EST_CODE_EXIST]);
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

	public MasterScore getMasterScore() {
		return entMasterScore;
	}

	public FrmMasterScore getForm() {
		return frmMasterScore;
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
	public long getGroupOidRes(){ 
		return this.groupOidRes;
	}

	public int action(int cmd, long oidMasterScore) {
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch (cmd) {
			case Command.ADD:
				break;

			case Command.SAVE:
				if (oidMasterScore != 0) {
					try {
						entMasterScore = PstMasterScore.fetchExc(oidMasterScore);
					} catch (Exception exc) {
					}
				}

				frmMasterScore.requestEntityObject(entMasterScore);

				if (frmMasterScore.errorSize() > 0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE;
				}

				if (entMasterScore.getOID() == 0) {
					try {
						long oid = pstMasterScore.insertExc(this.entMasterScore);
						this.oidRes = oid;
						this.groupOidRes = this.entMasterScore.getGroupId();
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
						long oid = pstMasterScore.updateExc(this.entMasterScore);
						this.oidRes = oid;
						this.groupOidRes = this.entMasterScore.getGroupId();
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}

				}
				break;

			case Command.EDIT:
				if (oidMasterScore != 0) {
					try {
						entMasterScore = PstMasterScore.fetchExc(oidMasterScore);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK:
				if (oidMasterScore != 0) {
					try {
						entMasterScore = PstMasterScore.fetchExc(oidMasterScore);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE:
				if (oidMasterScore != 0) {
					try {
						long oid = PstMasterScore.deleteExc(oidMasterScore);
						this.oidRes = oid;
						this.groupOidRes = this.entMasterScore.getGroupId();
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
