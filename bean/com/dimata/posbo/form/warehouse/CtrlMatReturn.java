package com.dimata.posbo.form.warehouse;

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
import com.dimata.qdep.entity.*;
import com.dimata.posbo.db.*;

/* project package */
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.session.warehouse.*;
import com.dimata.gui.jsp.ControlDate;
import com.dimata.common.entity.logger.PstDocLogger;
import com.dimata.common.entity.payment.PstStandartRate;
import com.dimata.common.entity.payment.StandartRate;

public class CtrlMatReturn extends Control implements I_Language {
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
    private MatReturn matReturn;
    private PstMatReturn pstMatReturn;
    private FrmMatReturn frmMatReturn;
    private HttpServletRequest req;
    int language = LANGUAGE_DEFAULT;
    
    public CtrlMatReturn(HttpServletRequest request) {
        msgString = "";
        matReturn = new MatReturn();
        try {
            pstMatReturn = new PstMatReturn(0);
        } catch (Exception e) {
            ;
        }
        req = request;
        frmMatReturn = new FrmMatReturn(request, matReturn);
    }
    
    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMatReturn.addError(frmMatReturn.FRM_FIELD_RETURN_MATERIAL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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
    
    public MatReturn getMatReturn() {
        return matReturn;
    }
    
    public FrmMatReturn getForm() {
        return frmMatReturn;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    public int action(int cmd, long oidMatReturn) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;
            case Command.SAVE:
                boolean incrementAllReturnType = true;
                Date rDate = new Date();
                int recType = 0;
                int counter = 0;
                if (oidMatReturn != 0) {
                    try {
                        matReturn = PstMatReturn.fetchExc(oidMatReturn);
                        rDate = matReturn.getReturnDate();
                        recType = matReturn.getReturnStatus();
                        counter = matReturn.getRetCodeCnt();
                    } catch (Exception exc) {
                    }
                }
                
                frmMatReturn.requestEntityObject(matReturn);
                Date date = ControlDate.getDateTime(frmMatReturn.fieldNames[FrmMatReturn.FRM_FIELD_RETURN_DATE], req);
                matReturn.setReturnDate(date);
                
                if (frmMatReturn.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                int docType = -1;
                try {
                    I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();
                    docType = i_pstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_ROMR);
                } catch (Exception e) {
                }
                
                /** Untuk mendapatkan besarnya standard rate per satuan default (:currency rate = 1)
                 * yang digunakan untuk nilai pada transaksi rate
                 * create by gwawan@dimata 3 Desember 2007
                 */
                if(this.matReturn.getCurrencyId() != 0) {
                    String whereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+" = "+this.matReturn.getCurrencyId();
                    whereClause += " AND "+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+" = "+PstStandartRate.ACTIVE;
                    Vector listStandardRate = PstStandartRate.list(0, 1, whereClause, "");
                    StandartRate objStandartRate = (StandartRate)listStandardRate.get(0);
                    this.matReturn.setTransRate(objStandartRate.getSellingRate());
                }
                else {
                    this.matReturn.setTransRate(0);
                }
                
                if (matReturn.getOID() == 0) {
                    try {
                        this.matReturn.setRetCodeCnt(SessMatReturn.getIntCode(matReturn, rDate, oidMatReturn, counter));
                        this.matReturn.setRetCode(SessMatReturn.getCodeReturn(matReturn));
                        matReturn.setLastUpdate(new Date());
                        long oid = pstMatReturn.insertExc(this.matReturn);
                        
                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        //PstDocLogger.insertDataBo_toDocLogger(matReturn.getRetCode(), I_DocType.MAT_DOC_TYPE_ROMR, matReturn.getLastUpdate(), matReturn.getRemark());
                        //--- end
                        
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
                        matReturn.setLastUpdate(new Date());
                        matReturn.setRetCodeCnt(counter);
                        long oid = pstMatReturn.updateExc(this.matReturn);
                        
                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        //PstDocLogger.updateDataBo_toDocLogger(matReturn.getRetCode(), I_DocType.MAT_DOC_TYPE_ROMR, matReturn.getLastUpdate(), matReturn.getRemark());
                        //--- end
                        
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.EDIT:
                if (oidMatReturn != 0) {
                    try {
                        matReturn = PstMatReturn.fetchExc(oidMatReturn);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK:
                if (oidMatReturn != 0) {
                    try {
                        matReturn = PstMatReturn.fetchExc(oidMatReturn);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE:
                if (oidMatReturn != 0) {
                    try {
                        
                        String whereClause = PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ID] + "=" + oidMatReturn;
                        Vector vect = PstMatReturnItem.list(0, 0, whereClause, "");
                        if (vect != null && vect.size() > 0) {
                            for (int k = 0; k < vect.size(); k++) {
                                MatReturnItem matDispatchItem = (MatReturnItem) vect.get(k);
                                CtrlMatReturnItem ctrlMatDpsItm = new CtrlMatReturnItem();
                                ctrlMatDpsItm.action(Command.DELETE, matDispatchItem.getOID(), oidMatReturn);
                            }
                        }
                        
                        /** gadnyan
                         * proses penghapusan di doc logger
                         * jika tidak di perlukan uncoment perintah ini
                         */
                        matReturn = PstMatReturn.fetchExc(oidMatReturn);
                        PstDocLogger.deleteDataBo_inDocLogger(matReturn.getRetCode(),I_DocType.MAT_DOC_TYPE_ROMR);
                        // -- end
                        
                        long oid = PstMatReturn.deleteExc(oidMatReturn);
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
                
            default :
                
        }
        return rsCode;
    }
}
