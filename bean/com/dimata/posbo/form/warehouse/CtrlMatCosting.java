package com.dimata.posbo.form.warehouse;

import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.qdep.entity.I_DocType;
import com.dimata.qdep.entity.I_IJGeneral;
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.posbo.entity.warehouse.PstMatCosting;
import com.dimata.posbo.entity.warehouse.MatCostingItem;
import com.dimata.posbo.entity.warehouse.PstMatCostingItem;
import com.dimata.posbo.entity.warehouse.MatCosting;
import com.dimata.posbo.session.warehouse.SessMatCosting;
import com.dimata.posbo.db.DBException;
import com.dimata.gui.jsp.ControlDate;
import com.dimata.common.entity.logger.PstDocLogger;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;
import java.util.Date;

public class CtrlMatCosting extends Control implements I_Language {
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;

    public static String[][] resultText =
            {
                {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
                {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
            };

    private int start;
    private String msgString;
    private MatCosting matCosting;
    private PstMatCosting pstMatCosting;
    private FrmMatCosting frmMatCosting;
    private HttpServletRequest req;
    int language = LANGUAGE_DEFAULT;
    long oid = 0;

    public CtrlMatCosting(HttpServletRequest request) {
        msgString = "";
        matCosting = new MatCosting();
        try {
            pstMatCosting = new PstMatCosting(0);
        } catch (Exception e) {
            ;
        }
        req = request;
        frmMatCosting = new FrmMatCosting(request, matCosting);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMatCosting.addError(frmMatCosting.FRM_FIELD_COSTING_MATERIAL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MatCosting getMatCosting() {
        return matCosting;
    }

    public FrmMatCosting getForm() {
        return frmMatCosting;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public long getOidTransfer() {
        return oid;
    }

    public int action(int cmd, long oidMatCosting) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMatCosting != 0) {
                    try {
                        matCosting = PstMatCosting.fetchExc(oidMatCosting);
                    } catch (Exception exc) {
                        System.out.println("Exception : " + exc.toString());
                    }
                }

                frmMatCosting.requestEntityObject(matCosting);
                Date date = ControlDate.getDateTime(FrmMatCosting.fieldNames[FrmMatCosting.FRM_FIELD_COSTING_DATE], req);
                matCosting.setCostingDate(date);

                if (oidMatCosting == 0) {
                    try {
                        SessMatCosting sessCosting = new SessMatCosting();
                        int maxCounter = sessCosting.getMaxCostingCounter(matCosting.getCostingDate(), matCosting);
                        maxCounter = maxCounter + 1;
                        matCosting.setCostingCodeCounter(maxCounter);
                        matCosting.setCostingCode(sessCosting.generateCostingCode(matCosting));
                        matCosting.setLastUpdate(new Date());
                        this.oid = pstMatCosting.insertExc(this.matCosting);

                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.insertDataBo_toDocLogger(matCosting.getCostingCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matCosting.getLastUpdate(), matCosting.getRemark());
                        //--- end

                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                } else {
                    try {
                        matCosting.setLastUpdate(new Date());
                        this.oid = pstMatCosting.updateExc(this.matCosting);

                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.updateDataBo_toDocLogger(matCosting.getCostingCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matCosting.getLastUpdate(), matCosting.getRemark());
                        //--- end

                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.EDIT:
                if (oidMatCosting != 0) {
                    try {
                        matCosting = PstMatCosting.fetchExc(oidMatCosting);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMatCosting != 0) {
                    try {
                        matCosting = PstMatCosting.fetchExc(oidMatCosting);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMatCosting != 0) {
                    try {
                        String whereClause = PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ID] + "=" + oidMatCosting;
                        Vector vect = PstMatCostingItem.list(0, 0, whereClause, "");
                        if (vect != null && vect.size() > 0) {
                            for (int k = 0; k < vect.size(); k++) {
                                MatCostingItem matCostingItem = (MatCostingItem) vect.get(k);
                                CtrlMatCostingItem ctrlMatDpsItm = new CtrlMatCostingItem();
                                ctrlMatDpsItm.action(Command.DELETE, matCostingItem.getOID(), oidMatCosting);
                            }
                        }
                        long oid = PstMatCosting.deleteExc(oidMatCosting);
                        if (oid != 0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        System.out.println("exception exc : " + exc.toString());
                    }
                }
                break;

            default :
                break;
        }
        return rsCode;
    }
}
