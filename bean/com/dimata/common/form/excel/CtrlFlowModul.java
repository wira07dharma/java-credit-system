/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.form.excel;

import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.common.entity.excel.*;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class CtrlFlowModul extends Control implements I_Language {

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
    private FlowModul entFlow;
    private PstFlowModul pstFlow;
    private FrmFlowModul frmFlow;
    int language = LANGUAGE_DEFAULT;

    public CtrlFlowModul(HttpServletRequest request) {
        msgString = "";
        entFlow = new FlowModul();
        try {
            pstFlow = new PstFlowModul(0);
        } catch (Exception e) {;
        }
        frmFlow = new FrmFlowModul(request, entFlow);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmFlow.addError(frmFlow.FRM_FIELD_FLOW_MODUL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public FlowModul getFlow() {
        return entFlow;
    }

    public FrmFlowModul getForm() {
        return frmFlow;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFlow) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidFlow != 0) {
                    try {
                        entFlow = PstFlowModul.fetchExc(oidFlow);
                    } catch (Exception exc) {
                    }
                }

                frmFlow.requestEntityObject(entFlow);

                if (frmFlow.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entFlow.getOID() == 0) {
                    try {
                        long oid = pstFlow.insertExc(this.entFlow);
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
                        long oid = pstFlow.updateExc(this.entFlow);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidFlow != 0) {
                    try {
                        entFlow = PstFlowModul.fetchExc(oidFlow);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidFlow != 0) {
                    try {
                        entFlow = PstFlowModul.fetchExc(oidFlow);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidFlow != 0) {
                    try {
                        long oid = PstFlowModul.deleteExc(oidFlow);
                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                            
                            String whereClause = PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]+"="+oid;
                            Vector listMapping = PstFlowModulMapping.list(0, 0, whereClause, "");
                            if (listMapping.size()>0){
                                for (int i=0; i< listMapping.size();i++){
                                    FlowModulMapping flowModulMapping = (FlowModulMapping) listMapping.get(i);
                                    try{
                                        String whereDataList = PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_ID]+"="+flowModulMapping.getOID();
                                        Vector listData = PstFlowMappingDataList.list(0, 0, whereDataList, "");
                                        PstFlowModulMapping.deleteExc(flowModulMapping.getOID());
                                        if (listData.size()>0){
                                            for (int x=0; x<listData.size();x++){
                                                FlowMappingDataList flowMappingDataList = (FlowMappingDataList) listData.get(x);
                                                PstFlowMappingDataList.deleteExc(flowMappingDataList.getOID());
                                            }
                                        }
                                    } catch (Exception exc){}
                                }
                            }
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