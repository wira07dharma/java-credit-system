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
import com.dimata.sedana.entity.analisakredit.AnalisaKreditDetail;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditDetail;

/*
Description : Controll AnalisaKreditDetail
Date : Tue Nov 26 2019
Author : ASUS
 */
public class CtrlAnalisaKreditDetail extends Control implements I_Language {

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
	private AnalisaKreditDetail entAnalisaKreditDetail;
	private PstAnalisaKreditDetail pstAnalisaKreditDetail;
	private FrmAnalisaKreditDetail frmAnalisaKreditDetail;
	int language = LANGUAGE_DEFAULT;

	public CtrlAnalisaKreditDetail(HttpServletRequest request) {
		msgString = "";
		entAnalisaKreditDetail = new AnalisaKreditDetail();
		try {
			pstAnalisaKreditDetail = new PstAnalisaKreditDetail(0);
		} catch (Exception e) {;
		}
		frmAnalisaKreditDetail = new FrmAnalisaKreditDetail(request, entAnalisaKreditDetail);
	}

	private String getSystemMessage(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				this.frmAnalisaKreditDetail.addError(frmAnalisaKreditDetail.FRM_FIELD_ANALISAKREDITDETAILID, resultText[language][RSLT_EST_CODE_EXIST]);
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

	public AnalisaKreditDetail getAnalisaKreditDetail() {
		return entAnalisaKreditDetail;
	}

	public FrmAnalisaKreditDetail getForm() {
		return frmAnalisaKreditDetail;
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

	public int action(int cmd, long oidAnalisaKreditDetail) {
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch (cmd) {
			case Command.ADD:
				break;

			case Command.SAVE:
				if (oidAnalisaKreditDetail != 0) {
					try {
						entAnalisaKreditDetail = PstAnalisaKreditDetail.fetchExc(oidAnalisaKreditDetail);
					} catch (Exception exc) {
					}
				}

				frmAnalisaKreditDetail.requestEntityObject(entAnalisaKreditDetail);

				if (frmAnalisaKreditDetail.errorSize() > 0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE;
				}

				if (entAnalisaKreditDetail.getOID() == 0) {
					try {
						this.oidRes = pstAnalisaKreditDetail.insertExc(this.entAnalisaKreditDetail);
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
						this.oidRes = pstAnalisaKreditDetail.updateExc(this.entAnalisaKreditDetail);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}

				}
				break;

			case Command.EDIT:
				if (oidAnalisaKreditDetail != 0) {
					try {
						entAnalisaKreditDetail = PstAnalisaKreditDetail.fetchExc(oidAnalisaKreditDetail);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK:
				if (oidAnalisaKreditDetail != 0) {
					try {
						entAnalisaKreditDetail = PstAnalisaKreditDetail.fetchExc(oidAnalisaKreditDetail);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE:
				if (oidAnalisaKreditDetail != 0) {
					try {
						this.oidRes = PstAnalisaKreditDetail.deleteExc(oidAnalisaKreditDetail);
						if (this.oidRes != 0) {
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
