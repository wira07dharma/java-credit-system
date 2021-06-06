/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Priska
 * @version  	:  [version]
 */

/*******************************************************************
 * Class Description 	: CtrlCompany
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Priska
 */
/* java package */
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;
/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
/* project package */
//import com.dimata.harisma.db.*;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.system.entity.PstSystemProperty;
import java.sql.*;

public class CtrlDocMaster extends Control implements I_Language{
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
    private DocMaster docMaster;
    private PstDocMaster pstDocMaster;
    private FrmDocMaster frmDocMaster;
    int language = LANGUAGE_DEFAULT;

    public CtrlDocMaster(HttpServletRequest request) {
        msgString = "";
        docMaster = new DocMaster();
        try {
            pstDocMaster = new PstDocMaster(0);
        } catch (Exception e) {
            ;
        }
        frmDocMaster = new FrmDocMaster(request, docMaster);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmDocMaster.addError(frmDocMaster.FRM_FIELD_DOC_MASTER_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public DocMaster getdDocMaster() {
        return docMaster;
    }

    public FrmDocMaster getForm() {
        return frmDocMaster;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidDocMaster) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

          case Command.SAVE :
				if(oidDocMaster != 0){
					try{
						docMaster = PstDocMaster.fetchExc(oidDocMaster);
					}catch(Exception exc){
					}
				}

				frmDocMaster.requestEntityObject(docMaster);

				if(frmDocMaster.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(docMaster.getOID()==0){
					try{
						long oid = pstDocMaster.insertExc(this.docMaster);
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
						long oid = pstDocMaster.updateExc(this.docMaster);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidDocMaster != 0) {
					try {
						docMaster = PstDocMaster.fetchExc(oidDocMaster);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidDocMaster != 0) {
					try {
						docMaster = PstDocMaster.fetchExc(oidDocMaster);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;


			case Command.DELETE :
				if (oidDocMaster != 0){
					try{
						long oid = PstDocMaster.deleteExc(oidDocMaster);
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
