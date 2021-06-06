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
import com.dimata.sedana.entity.analisakredit.AnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;

/*
Description : Controll AnalisaKreditMain
Date : Tue Nov 26 2019
Author : ASUS
 */
public class CtrlAnalisaKreditMain extends Control implements I_Language {

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
	private String defNumFormat = "F5C";
	private AnalisaKreditMain entAnalisaKreditMain;
	private PstAnalisaKreditMain pstAnalisaKreditMain;
	private FrmAnalisaKreditMain frmAnalisaKreditMain;
	int language = LANGUAGE_DEFAULT;

	public CtrlAnalisaKreditMain(HttpServletRequest request) {
		msgString = "";
		entAnalisaKreditMain = new AnalisaKreditMain();
		try {
			pstAnalisaKreditMain = new PstAnalisaKreditMain(0);
		} catch (Exception e) {;
		}
		frmAnalisaKreditMain = new FrmAnalisaKreditMain(request, entAnalisaKreditMain);
	}

	private String getSystemMessage(int msgCode) {
		switch (msgCode) {
			case I_DBExceptionInfo.MULTIPLE_ID:
				this.frmAnalisaKreditMain.addError(frmAnalisaKreditMain.FRM_FIELD_ANALISAKREDITMAINID, resultText[language][RSLT_EST_CODE_EXIST]);
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

	public AnalisaKreditMain getAnalisaKreditMain() {
		return entAnalisaKreditMain;
	}

	public FrmAnalisaKreditMain getForm() {
		return frmAnalisaKreditMain;
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

	public int action(int cmd, long oidAnalisaKreditMain) {
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch (cmd) {
			case Command.ADD:
				break;

			case Command.SAVE:
				if (oidAnalisaKreditMain != 0) {
					try {
						entAnalisaKreditMain = PstAnalisaKreditMain.fetchExc(oidAnalisaKreditMain);
					} catch (Exception exc) {
					}
				}

				frmAnalisaKreditMain.requestEntityObject(entAnalisaKreditMain);

				if (frmAnalisaKreditMain.errorSize() > 0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE;
				}

				if(entAnalisaKreditMain.getAnalisaNumber().equals("")){
					try {
						Pinjaman p = PstPinjaman.fetchExc(entAnalisaKreditMain.getPinjamanId());
						String cusNum = defNumFormat + "-" + p.getNoKredit();
						entAnalisaKreditMain.setAnalisaNumber(cusNum);
					} catch (Exception e) {
					}
				}
				
				if(entAnalisaKreditMain.getAnalisaStatus() == PstAnalisaKreditMain.ANALISA_STATUS_CLOSED){
					if(entAnalisaKreditMain.getDivisionHeadId() == 0 && entAnalisaKreditMain.getManagerId() == 0){
						return 0;
					}
				}
				
				if (entAnalisaKreditMain.getOID() == 0) {
					try {
						long oid = pstAnalisaKreditMain.insertExc(this.entAnalisaKreditMain);
						this.oidRes = oid;
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
						long oid = pstAnalisaKreditMain.updateExc(this.entAnalisaKreditMain);
						this.oidRes = oid;
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}

				}
				break;

			case Command.EDIT:
				if (oidAnalisaKreditMain != 0) {
					try {
						entAnalisaKreditMain = PstAnalisaKreditMain.fetchExc(oidAnalisaKreditMain);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK:
				if (oidAnalisaKreditMain != 0) {
					try {
						entAnalisaKreditMain = PstAnalisaKreditMain.fetchExc(oidAnalisaKreditMain);
					} catch (DBException dbexc) {
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc) {
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE:
				if (oidAnalisaKreditMain != 0) {
					try {
						long oid = PstAnalisaKreditMain.deleteExc(oidAnalisaKreditMain);
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
