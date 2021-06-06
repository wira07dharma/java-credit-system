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

public class CtrlEmpDoc extends Control implements I_Language{
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
    private EmpDoc empDoc;
    private PstEmpDoc pstEmpDoc;
    private FrmEmpDoc frmEmpDoc;
    int language = LANGUAGE_DEFAULT;

    public CtrlEmpDoc(HttpServletRequest request) {
        msgString = "";
        empDoc = new EmpDoc();
        try {
            pstEmpDoc = new PstEmpDoc(0);
        } catch (Exception e) {
            ;
        }
        frmEmpDoc = new FrmEmpDoc(request, empDoc);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmEmpDoc.addError(frmEmpDoc.FRM_FIELD_EMP_DOC_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public EmpDoc getEmpDoc() {
        return empDoc;
    }

    public FrmEmpDoc getForm() {
        return frmEmpDoc;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidEmpDoc) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

          case Command.SAVE :
				if(oidEmpDoc != 0){
					try{
						empDoc = PstEmpDoc.fetchExc(oidEmpDoc);
					}catch(Exception exc){
					}
				}

				frmEmpDoc.requestEntityObject(empDoc);

				if(frmEmpDoc.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(empDoc.getOID()==0){
					try{
						long oid = pstEmpDoc.insertExc(this.empDoc);
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
						long oid = pstEmpDoc.updateExc(this.empDoc);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidEmpDoc != 0) {
					try {
						empDoc = PstEmpDoc.fetchExc(oidEmpDoc);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidEmpDoc != 0) {
					try {
						empDoc = PstEmpDoc.fetchExc(oidEmpDoc);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;


			case Command.DELETE :
				if (oidEmpDoc != 0){
					try{
						long oid = PstEmpDoc.deleteExc(oidEmpDoc);
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
                            case Command.POST :
                                EmpDoc empDocNew = new EmpDoc();
				if(oidEmpDoc != 0){
					try{
						empDocNew = PstEmpDoc.fetchExc(oidEmpDoc);
					}catch(Exception exc){
					}
				}

				frmEmpDoc.requestEntityObject(empDoc);

				empDocNew.setDetails(this.empDoc.getDetails());


                                try {
                                        long oid = pstEmpDoc.updateExc(empDocNew);
                                }catch (DBException dbexc){
                                        excCode = dbexc.getErrorCode();
                                        msgString = getSystemMessage(excCode);
                                }catch (Exception exc){
                                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
                                }

				
				break;

			default :

		}
		return rsCode;
	}
}
