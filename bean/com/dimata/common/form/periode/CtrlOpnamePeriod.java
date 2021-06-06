/* 
 * Ctrl Name  		:  CtrlMcdPeriode.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.form.periode;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.common.entity.periode.PstOpnamePeriod;
import com.dimata.common.entity.periode.OpnamePeriod;
//import com.dimata.material.entity.masterdata.PstMaterialPeriode;

public class CtrlOpnamePeriod extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private OpnamePeriod periode;
	private PstOpnamePeriod pstOpnamePeriod;
	private FrmOpnamePeriod frmOpnamePeriod;
	int language = LANGUAGE_DEFAULT;

	public CtrlOpnamePeriod(HttpServletRequest request){
		msgString = "";
		periode = new OpnamePeriod();
		try{
			pstOpnamePeriod = new PstOpnamePeriod(0);
		}catch(Exception e){;}
		frmOpnamePeriod = new FrmOpnamePeriod(request, periode);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				this.frmOpnamePeriod.addError(frmOpnamePeriod.FRM_FIELD_END_DATE, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR]; 
		}
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage(){ return language; }

	public void setLanguage(int language){ this.language = language; }

	public OpnamePeriod getOpnamePeriod() { return periode; }

	public FrmOpnamePeriod getForm() { return frmOpnamePeriod; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidOpnamePeriod){
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case Command.ADD :
				break;

			case Command.SAVE :
				//mOpnamePeriod = new OpnamePeriod();
				if(oidOpnamePeriod != 0){
					try{
						periode = PstOpnamePeriod.fetchExc(oidOpnamePeriod);
					}catch(Exception exc){
					}
				}

				frmOpnamePeriod.requestEntityObject(periode);
                //periode.setOID(mOpnamePeriod.getOID());
                //periode.setPeriodeType(mOpnamePeriod.getPeriodeType());
                //periode.setStartDate(mOpnamePeriod.getStartDate());
                //periode.setEndDate(mOpnamePeriod.getEndDate());
                //periode.setStatus(mOpnamePeriod.getStatus());

				if(frmOpnamePeriod.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(periode.getOID()==0){
					try{
                        //periode.setStatus(PstMaterialPeriode.STATUS_OPEN);
						long oid = pstOpnamePeriod.insertExc(this.periode);
					}catch(DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
						return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
					}

				}else{
					try {
						long oid = pstOpnamePeriod.updateExc(this.periode);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidOpnamePeriod != 0) {
					try {
						periode = PstOpnamePeriod.fetchExc(oidOpnamePeriod);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidOpnamePeriod != 0) {
					try {
						periode = PstOpnamePeriod.fetchExc(oidOpnamePeriod);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE :
				if (oidOpnamePeriod != 0){
					try{
						long oid = PstOpnamePeriod.deleteExc(oidOpnamePeriod);
						if(oid!=0){
							msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
					}catch(DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}
}
