/* 
 * Ctrl Name  		:  CtrlDiscountType.java 
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

package com.dimata.posbo.form.warehouse;

import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.posbo.entity.warehouse.PstMaterialStockCode;
import com.dimata.posbo.entity.warehouse.MaterialStockCode;
import com.dimata.posbo.db.DBException;

import javax.servlet.http.HttpServletRequest;

public class CtrlMaterialStockCode extends Control implements I_Language
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
	private MaterialStockCode materialStockCode;
	private PstMaterialStockCode pstMaterialStockCode;
	private FrmMaterialStockCode frmMaterialStockCode;
	int language = LANGUAGE_DEFAULT;

	public CtrlMaterialStockCode(HttpServletRequest request){
		msgString = "";
		materialStockCode = new MaterialStockCode();
		try{
			pstMaterialStockCode = new PstMaterialStockCode(0);
		}catch(Exception e){;}
		frmMaterialStockCode = new FrmMaterialStockCode(request, materialStockCode);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				this.frmMaterialStockCode.addError(FrmMaterialStockCode.FRM_FIELD_MATERIAL_STOCK_CODE_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public MaterialStockCode getMaterialStockCode() { return materialStockCode; }

	public FrmMaterialStockCode getForm() { return frmMaterialStockCode; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidMaterialStockCode){
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case Command.ADD :
				break;

			case Command.SAVE :
				if(oidMaterialStockCode != 0){
					try{
						materialStockCode = PstMaterialStockCode.fetchExc(oidMaterialStockCode);
					}catch(Exception exc){
					}
				}

				frmMaterialStockCode.requestEntityObject(materialStockCode);

				if(frmMaterialStockCode.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(materialStockCode.getOID()==0){
					try{
						long oid = pstMaterialStockCode.insertExc(this.materialStockCode);
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
						long oid = pstMaterialStockCode.updateExc(this.materialStockCode);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidMaterialStockCode != 0) {
					try {
						materialStockCode = PstMaterialStockCode.fetchExc(oidMaterialStockCode);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidMaterialStockCode != 0) {
					try {
						materialStockCode = PstMaterialStockCode.fetchExc(oidMaterialStockCode);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE :
				if (oidMaterialStockCode != 0){
					try{
						long oid = PstMaterialStockCode.deleteExc(oidMaterialStockCode);
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
