package com.dimata.posbo.form.warehouse;

/* java package */

import com.dimata.common.entity.payment.CurrencyType;
import com.dimata.common.entity.payment.PstCurrencyType;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;

/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.entity.*;
import com.dimata.qdep.form.*;
import com.dimata.posbo.db.*;

/* project package */
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.form.warehouse.*;
import com.dimata.posbo.session.warehouse.*;
import com.dimata.gui.jsp.ControlDate;
import com.dimata.common.entity.logger.PstDocLogger;
import com.dimata.common.entity.payment.StandartRate;
import com.dimata.common.entity.payment.PstStandartRate;

/*import payment terms */
import com.dimata.posbo.entity.arap.PaymentTerms;
import com.dimata.posbo.entity.arap.PstPaymentTerms;

public class CtrlMatReceive extends Control implements I_Language {
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
    private MatReceive matReceive;
    private PstMatReceive pstMatReceive;
    private FrmMatReceive frmMatReceive;
    private HttpServletRequest req;
    int language = LANGUAGE_DEFAULT;
    
    public CtrlMatReceive(HttpServletRequest request) {
        msgString = "";
        matReceive = new MatReceive();
        try {
            pstMatReceive = new PstMatReceive(0);
        } catch (Exception e) {
            ;
        }
        req = request;
        frmMatReceive = new FrmMatReceive(request, matReceive);
    }
    
    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMatReceive.addError(frmMatReceive.FRM_FIELD_RECEIVE_MATERIAL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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
    
    public MatReceive getMatReceive() {
        return matReceive;
    }
    
    public FrmMatReceive getForm() {
        return frmMatReceive;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    public int action(int cmd, long oidMatReceive) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;
            case Command.SAVE:
                boolean incrementAllReceiveType = true;
                Date rDate = new Date();
                int recType = 0;
                int counter = 0;
                if (oidMatReceive != 0) {
                    try {
                        matReceive = PstMatReceive.fetchExc(oidMatReceive);
                        rDate = matReceive.getReceiveDate();
                        recType = matReceive.getReceiveStatus();
                        counter = matReceive.getRecCodeCnt();
                    } catch (Exception exc) {
                        System.out.println("Exc. when fetch  MatReceive: "+exc.toString());
                    }
                }
                
                frmMatReceive.requestEntityObject(matReceive);
                Date date = ControlDate.getDateTime(FrmMatReceive.fieldNames[FrmMatReceive.FRM_FIELD_RECEIVE_DATE],req);
                matReceive.setReceiveDate(date);
                
                int docType = -1;
                try {
                    I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();
                    docType = i_pstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_LMRR);
                } catch (Exception e) {
                    System.out.println("Exc : "+e.toString());
                }
                
                if (frmMatReceive.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                // set currency id untuk penerimaan antar lokasi
                CurrencyType defaultCurrencyType = new CurrencyType();
                if(this.matReceive.getSupplierId() == 0 && this.matReceive.getCurrencyId() == 0) {
                    defaultCurrencyType = PstCurrencyType.getDefaultCurrencyType();
                    this.matReceive.setCurrencyId(defaultCurrencyType.getOID());
                }
                
                /** Untuk mendapatkan besarnya standard rate per satuan default (:currency rate = 1)
                 * yang digunakan untuk nilai pada transaksi rate
                 * create by gwawan@dimata 16 Agutus 2007
                 */
                if(this.matReceive.getCurrencyId() != 0) {
                    String whereClause = PstStandartRate.fieldNames[PstStandartRate.FLD_CURRENCY_TYPE_ID]+" = "+this.matReceive.getCurrencyId();
                    whereClause += " AND "+PstStandartRate.fieldNames[PstStandartRate.FLD_STATUS]+" = "+PstStandartRate.ACTIVE;
                    Vector listStandardRate = PstStandartRate.list(0, 1, whereClause, "");
                    StandartRate objStandartRate = (StandartRate)listStandardRate.get(0);
                    this.matReceive.setTransRate(objStandartRate.getSellingRate());
                }
                else {
                    this.matReceive.setTransRate(0);
                }
                
                if (matReceive.getOID() == 0) {
                    try {
                        this.matReceive.setRecCodeCnt(SessMatReceive.getIntCode(matReceive, rDate, oidMatReceive, docType, counter, incrementAllReceiveType));
                        this.matReceive.setRecCode(SessMatReceive.getCodeReceive(matReceive));
                        matReceive.setLastUpdate(new Date());
                        long oid = pstMatReceive.insertExc(this.matReceive);

                       
                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        //PstDocLogger.insertDataBo_toDocLogger(matReceive.getRecCode(), I_IJGeneral.DOC_TYPE_PURCHASE_ON_LGR, matReceive.getLastUpdate(), matReceive.getRemark());
                        //--- end
                        System.out.println("action comlpete....");
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        System.out.println("exception: "+exc.toString());
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                } else {
                    try {
                        matReceive.setLastUpdate(new Date());
                        long oid = pstMatReceive.updateExc(this.matReceive);
                        
                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.updateDataBo_toDocLogger(matReceive.getRecCode(), I_IJGeneral.DOC_TYPE_PURCHASE_ON_LGR, matReceive.getLastUpdate(), matReceive.getRemark());
                        //--- end
                        
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                
                /** set status pada forwarder info dengan value terkini! */
                try {
                    String whereClause = ""+PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_RECEIVE_ID]+"="+this.matReceive.getOID();
                    Vector vctListFi = PstForwarderInfo.list(0, 0, whereClause, "");
                    ForwarderInfo forwarderInfo = new ForwarderInfo();
                    for(int j=0; j<vctListFi.size(); j++) {
                        forwarderInfo = (ForwarderInfo)vctListFi.get(j);
                        forwarderInfo.setStatus(this.matReceive.getReceiveStatus());
                        long oid = PstForwarderInfo.updateExc(forwarderInfo);
                    }
                }
                catch(Exception e) {
                    System.out.println("Exc in update status, forwarder_info >>> "+e.toString());
                }
                
                break;
                
            case Command.EDIT:
                if (oidMatReceive != 0) {
                    try {
                        matReceive = PstMatReceive.fetchExc(oidMatReceive);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK:
                if (oidMatReceive != 0) {
                    try {
                        matReceive = PstMatReceive.fetchExc(oidMatReceive);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE:
                if (oidMatReceive != 0) {
                    try {
                        // memproses item penerimaan barang
                        CtrlMatReceiveItem objCtlItem = new CtrlMatReceiveItem();
                        MatReceiveItem objItem = new MatReceiveItem();
                        String stWhereClose = PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] + " = " + oidMatReceive;
                        Vector vListItem = PstMatReceiveItem.list(0, 0, stWhereClose, "");
                        if (vListItem != null && vListItem.size() > 0) {
                            for (int i = 0; i < vListItem.size(); i++) {
                                objItem = (MatReceiveItem) vListItem.get(i);
                                objCtlItem.action(Command.DELETE, objItem.getOID(), oidMatReceive);
                            }
                        }
                        
                        /** gadnyan
                         * proses penghapusan di doc logger
                         * jika tidak di perlukan uncoment perintah ini
                         */
                        matReceive = PstMatReceive.fetchExc(oidMatReceive);
                        PstDocLogger.deleteDataBo_inDocLogger(matReceive.getRecCode(),I_DocType.MAT_DOC_TYPE_LMRR);
                        // -- end
                        
                        
                        /** delete forwarder information berdasarkan dok. receive */
                        String whereClause = ""+PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_RECEIVE_ID]+"="+matReceive.getOID();
                        Vector vctListFi = PstForwarderInfo.list(0, 0, whereClause, "");
                        ForwarderInfo forwarderInfo = new ForwarderInfo();
                        CtrlForwarderInfo ctrlForwarderInfo = new CtrlForwarderInfo();
                        for(int j=0; j<vctListFi.size(); j++) {
                            forwarderInfo = (ForwarderInfo)vctListFi.get(j);
                            ctrlForwarderInfo.action(Command.DELETE, forwarderInfo.getOID());
                        }
                        
                        /** delete receive */
                        long oid = PstMatReceive.deleteExc(oidMatReceive);
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
