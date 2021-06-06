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
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.posbo.entity.warehouse.PstDispatchStockCode;
import com.dimata.posbo.entity.warehouse.DispatchStockCode;
import com.dimata.posbo.entity.warehouse.PstMaterialStockCode;
import com.dimata.posbo.entity.warehouse.MaterialStockCode;
import com.dimata.posbo.db.DBException;
import com.dimata.posbo.entity.warehouse.MatDispatchItem;
import com.dimata.posbo.entity.warehouse.PstMatDispatchItem;

import javax.servlet.http.HttpServletRequest;

public class CtrDispatchStockCode extends Control implements I_Language {
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
    private DispatchStockCode dispatchStockCode;
    private PstDispatchStockCode pstDispatchStockCode;
    private FrmDispatchStockCode frmDispatchStockCode;
    private HttpServletRequest req;
    private String strError = "";
    int language = LANGUAGE_DEFAULT;

    public String getStrError() {
        return strError;
    }

    public CtrDispatchStockCode(HttpServletRequest request) {
        msgString = "";
        dispatchStockCode = new DispatchStockCode();
        try {
            pstDispatchStockCode = new PstDispatchStockCode(0);
        } catch (Exception e) {
            ;
        }
        frmDispatchStockCode = new FrmDispatchStockCode(request, dispatchStockCode);
        req = request;
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmDispatchStockCode.addError(FrmDispatchStockCode.FRM_FIELD_MATERIAL_DISPATCH_CODE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public DispatchStockCode getDispatchStockCode() {
        return dispatchStockCode;
    }

    public FrmDispatchStockCode getForm() {
        return frmDispatchStockCode;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidDispatchStockCode) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidDispatchStockCode != 0) {
                    try {
                        dispatchStockCode = PstDispatchStockCode.fetchExc(oidDispatchStockCode);
                    } catch (Exception exc) {
                    }
                }

                frmDispatchStockCode.requestEntityObject(dispatchStockCode);

                if (frmDispatchStockCode.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (dispatchStockCode.getOID() == 0) {
                    try {
                        long oid = pstDispatchStockCode.insertExc(this.dispatchStockCode);
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
                        long oid = pstDispatchStockCode.updateExc(this.dispatchStockCode);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidDispatchStockCode != 0) {
                    try {
                        dispatchStockCode = PstDispatchStockCode.fetchExc(oidDispatchStockCode);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidDispatchStockCode != 0) {
                    try {
                        dispatchStockCode = PstDispatchStockCode.fetchExc(oidDispatchStockCode);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidDispatchStockCode != 0) {
                    try {
                        MatDispatchItem matDispatchItem = new MatDispatchItem();
                        try {
                            dispatchStockCode = PstDispatchStockCode.fetchExc(oidDispatchStockCode);
                            matDispatchItem = PstMatDispatchItem.fetchExc(dispatchStockCode.getDispatchMaterialItemId());
                        } catch (Exception exc) {
                        }
                        // proses delete serial code di dispatch
                        long oid = PstDispatchStockCode.deleteExc(oidDispatchStockCode);

                        // proses update serial di stock code
                        try {
                            MaterialStockCode materialStockCode = PstMaterialStockCode.cekExistByCode(dispatchStockCode.getStockCode(), matDispatchItem.getMaterialId());
                            materialStockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_GOOD);
                            PstMaterialStockCode.updateExc(materialStockCode);
                        } catch (Exception e) {
                        }

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

    /**
     * ini untuk get request
     * @param vList
     * @param req
     */
    public String requestBarcode(int cnt, long oid, HttpServletRequest req) {
        try {
            for (int k = 0; k < cnt; k++) {
                int sts_chk = FRMQueryString.requestInt(req, "" + FrmSourceStockCode.fieldNames[FrmSourceStockCode.FRM_FIELD_STOCK_CODE] + "_" + k);
                //System.out.println("sts_chk : " + sts_chk);
                if (sts_chk != 0) {
                    // proses update status stock code
                    long oidStockCode = FRMQueryString.requestLong(req, "" + FrmSourceStockCode.fieldNames[FrmSourceStockCode.FRM_FIELD_STOCK_CODE] + "_st_" + k);
                    try {
                        MaterialStockCode materialStockCode = PstMaterialStockCode.fetchExc(oidStockCode);
                        materialStockCode.setStockStatus(PstMaterialStockCode.FLD_STOCK_STATUS_PROCESS);
                        PstMaterialStockCode.updateExc(materialStockCode);
                    } catch (Exception e) {
                    }

                    String strBrc = FRMQueryString.requestString(req, "txt_code_" + k);
                    DispatchStockCode dispatchStockCode = new DispatchStockCode();
                    dispatchStockCode.setDispatchMaterialItemId(oid);
                    dispatchStockCode.setStockCode(strBrc);
                    try {
                        PstDispatchStockCode.insertExc(dispatchStockCode);
                        strError = "Data sudah tersimpan.";
                    } catch (Exception e) {
                        strError = "Data tidak dapat disimpan.";
                    }
                }
            }
        } catch (Exception e) {
            strError = "Data tidak dapat disimpan.";
        }
        return "";
    }
}
