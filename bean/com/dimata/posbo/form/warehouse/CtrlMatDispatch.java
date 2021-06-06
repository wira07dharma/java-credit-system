package com.dimata.posbo.form.warehouse;

/* java package */

import java.util.*;
import javax.servlet.http.*;

import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.entity.I_DocType;
import com.dimata.qdep.entity.I_IJGeneral;
import com.dimata.posbo.db.*;
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.session.warehouse.*;
import com.dimata.gui.jsp.ControlDate;
import com.dimata.common.entity.logger.PstDocLogger;
//generate oid
import com.dimata.posbo.db.OIDFactory;

public class CtrlMatDispatch extends Control implements I_Language {
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
    private MatDispatch matDispatch;
    private PstMatDispatch pstMatDispatch;
    private FrmMatDispatch frmMatDispatch;
    private HttpServletRequest req;
    int language = LANGUAGE_DEFAULT;
    long oid = 0;
    //for receive item
    private OIDFactory oidFactory = new OIDFactory();

    public CtrlMatDispatch(HttpServletRequest request) {
        msgString = "";
        matDispatch = new MatDispatch();
        try {
            pstMatDispatch = new PstMatDispatch(0);
        } catch (Exception e) {
            ;
        }
        req = request;
        frmMatDispatch = new FrmMatDispatch(request, matDispatch);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMatDispatch.addError(frmMatDispatch.FRM_FIELD_DISPATCH_MATERIAL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MatDispatch getMatDispatch() {
        return matDispatch;
    }

    public FrmMatDispatch getForm() {
        return frmMatDispatch;
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

    public int action(int cmd, long oidMatDispatch) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMatDispatch != 0) {
                    try {
                        matDispatch = PstMatDispatch.fetchExc(oidMatDispatch);
                    } catch (Exception exc) {
                        System.out.println("Exception : " + exc.toString());
                    }
                }

                frmMatDispatch.requestEntityObject(matDispatch);
                Date date = ControlDate.getDateTime(FrmMatDispatch.fieldNames[FrmMatDispatch.FRM_FIELD_DISPATCH_DATE], req);
                matDispatch.setDispatchDate(date);

                //for getting location type
                  int LocationType = matDispatch.getLocationType();
                //End of getting location type



                if (oidMatDispatch == 0 && LocationType != PstMatDispatch.FLD_TYPE_TRANSFER_UNIT) {
                    try {
                        SessMatDispatch sessDispatch = new SessMatDispatch();
                        int maxCounter = sessDispatch.getMaxDispatchCounter(matDispatch.getDispatchDate(), matDispatch);
                        maxCounter = maxCounter + 1;
                        matDispatch.setDispatchCodeCounter(maxCounter);
                        matDispatch.setDispatchCode(sessDispatch.generateDispatchCode(matDispatch));
                        matDispatch.setLast_update(new Date());
                        this.oid = pstMatDispatch.insertExc(this.matDispatch);


                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.insertDataBo_toDocLogger(matDispatch.getDispatchCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matDispatch.getLast_update(), matDispatch.getRemark());
                        //--- end

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                     /*
                      * Automatically Making a new Document for Receive Material
                      * if Dispatch Unit was creating
                      * Document Number is same with Dispatch Unit
                      * By Mirahu
                      */
                if (oidMatDispatch == 0 && LocationType== PstMatDispatch.FLD_TYPE_TRANSFER_UNIT ) {
                     try {
                        SessMatDispatch sessDispatch = new SessMatDispatch();
                        int maxCounter = sessDispatch.getMaxDispatchUnitCounter(matDispatch.getDispatchDate(), matDispatch);
                        maxCounter = maxCounter + 1;
                        matDispatch.setDispatchCodeCounter(maxCounter);
                        matDispatch.setDispatchCode(sessDispatch.generateDispatchUnitCode(matDispatch));
                        matDispatch.setLast_update(new Date());
                        this.oid = pstMatDispatch.insertExc(this.matDispatch);

                        /*
                         * Automatically Making a new Document for Receive Material
                         * if Dispatch Unit was creating
                         * Document Number is same with Dispatch Unit
                         * By Mirahu
                         */

                        if(matDispatch.getLocationType()== PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){
                            //matDispatch = pstMatDispatch.fetchExc(oid);
                            MatReceive matReceive = new MatReceive();
                            matReceive.setOID(oidFactory.generateOID());
                            matReceive.setLocationId(matDispatch.getDispatchTo());
                            matReceive.setLocationType(matDispatch.getLocationType());
                            matReceive.setReceiveDate(matDispatch.getDispatchDate());
                            matReceive.setReceiveStatus(matDispatch.getDispatchStatus());
                            matReceive.setReceiveSource(PstMatReceive.SOURCE_FROM_DISPATCH_UNIT);
                            matReceive.setRemark("Automatic Receive process from transfer unit number : " + matDispatch.getDispatchCode());
                            matReceive.setReceiveFrom(matDispatch.getLocationId());
                            matReceive.setRecCode(matDispatch.getDispatchCode());
                            matReceive.setRecCodeCnt(matDispatch.getDispatchCodeCounter());
                            matReceive.setDispatchMaterialId(matDispatch.getOID());
                            PstMatReceive.insertExc(matReceive);
                        }
                        /*
                         * End of making a new Document for receive material
                         */

                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.insertDataBo_toDocLogger(matDispatch.getDispatchCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matDispatch.getLast_update(), matDispatch.getRemark());
                        //--- end

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                 }

                     /*
                      * End of making a new Document for receive material
                      */

               // } else {
                  else {
                    try {
                        matDispatch.setLast_update(new Date());
                        this.oid = pstMatDispatch.updateExc(this.matDispatch);

                        /*
                         * Updating Doc Receive Material if dispatch Unit was updating
                         * By Mirahu
                         */
                        if(matDispatch.getLocationType()== PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){
                            long oidRecMaterial = PstMatReceive.getOidReceiveMaterial(oidMatDispatch);
                            MatReceive matReceive = new MatReceive();
                            matReceive = PstMatReceive.fetchExc(oidRecMaterial);
                            matReceive.setLocationId(matDispatch.getDispatchTo());
                            matReceive.setReceiveDate(matDispatch.getDispatchDate());
                            matReceive.setReceiveStatus(matDispatch.getDispatchStatus());
                            matReceive.setReceiveFrom(matDispatch.getLocationId());
                            matReceive.setLastUpdate(new Date());
                            PstMatReceive.updateExc(matReceive);
                        }
                        /*
                         * End of Updating receive material
                         */


                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        PstDocLogger.updateDataBo_toDocLogger(matDispatch.getDispatchCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matDispatch.getLast_update(), matDispatch.getRemark());
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
                if (oidMatDispatch != 0) {
                    try {
                        matDispatch = PstMatDispatch.fetchExc(oidMatDispatch);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMatDispatch != 0) {
                    try {
                        matDispatch = PstMatDispatch.fetchExc(oidMatDispatch);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMatDispatch != 0) {
                    try {

                         /** by mirahu
                         * proses penghapusan di pos dispatch receive item
                         */
                       String whereClauseTransferUnit = PstMatDispatchReceiveItem.fieldNames[PstMatDispatchReceiveItem.FLD_DISPATCH_MATERIAL_ID] + "=" + oidMatDispatch;
                        Vector vect2 = PstMatDispatchReceiveItem.list(0, 0, whereClauseTransferUnit, "");
                        if (vect2 != null && vect2.size() > 0) {
                            for (int k = 0; k < vect2.size(); k++) {
                                MatDispatchReceiveItem matDispatchReceiveItem = (MatDispatchReceiveItem) vect2.get(k);
                                CtrlMatDispatchReceiveItem ctrlMatDpsRecItm = new CtrlMatDispatchReceiveItem();
                                ctrlMatDpsRecItm.action(Command.DELETE, matDispatchReceiveItem.getOID(),0, oidMatDispatch,0,-1);
                            }
                        }
                        /*End Of delete pos dispatch receive item*/

                        String whereClause = PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] + "=" + oidMatDispatch;
                        Vector vect = PstMatDispatchItem.list(0, 0, whereClause, "");
                        if (vect != null && vect.size() > 0) {
                            for (int k = 0; k < vect.size(); k++) {
                                MatDispatchItem matDispatchItem = (MatDispatchItem) vect.get(k);
                                CtrlMatDispatchItem ctrlMatDpsItm = new CtrlMatDispatchItem();
                                ctrlMatDpsItm.action(Command.DELETE, matDispatchItem.getOID(), oidMatDispatch);
                            }
                        }

                        
                        
                        /** gadnyan
                         * proses penghapusan di doc logger
                         * jika tidak di perlukan uncoment perintah ini
                         */
                        matDispatch = PstMatDispatch.fetchExc(oidMatDispatch);
                        PstDocLogger.deleteDataBo_inDocLogger(matDispatch.getDispatchCode(), I_DocType.MAT_DOC_TYPE_DF);
                        // -- end
                        
                        /*
                         * Deleting Doc receive Material if Dispatch Unit was deleting
                         * By Mirahu
                         */
                        if(matDispatch.getLocationType()== PstMatDispatch.FLD_TYPE_TRANSFER_UNIT){
                            long oidRecMaterial = PstMatReceive.getOidReceiveMaterial(oidMatDispatch);
                            //MatReceive matReceive = new MatReceive();
                            //matReceive = PstMatReceive.fetchExc(oidRecMaterial);
                            long oidRec = PstMatReceive.deleteExc(oidRecMaterial);
                              if (oidRec != 0) {
                                msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                                excCode = RSLT_OK;
                              } else {
                                msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                                excCode = RSLT_FORM_INCOMPLETE;
                              }
                        }
                        /*
                         * End of Deleting Doc receive Material
                         */

                        long oid = PstMatDispatch.deleteExc(oidMatDispatch);
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
                        System.out.println("exception dbexc : " + dbexc.toString());
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
