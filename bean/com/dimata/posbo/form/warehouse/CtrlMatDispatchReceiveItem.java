/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



package com.dimata.posbo.form.warehouse;

import java.util.*;
import javax.servlet.http.*;

import com.dimata.posbo.entity.warehouse.*;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.posbo.db.DBException;
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.posbo.db.OIDFactory;
import com.dimata.posbo.session.warehouse.SessMatDispatchReceive;



import javax.servlet.http.HttpServletRequest;

public class CtrlMatDispatchReceiveItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;

    public static final int COMMAND_TYPE_GROUP = 0;
    public static final int COMMAND_TYPE_ITEM = 1;

    public static String[][] resultText =
            {
                {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
                {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
            };

    private int start;
    private String msgString;
    private MatDispatchReceiveItem matDispatchReceiveItem;
    private PstMatDispatchReceiveItem pstMatDispatchReceiveItem;
    private FrmMatDispatchReceiveItem frmMatDispatchReceiveItem;
    private HttpServletRequest req;
    private OIDFactory oidFactory = new OIDFactory();
    int language = LANGUAGE_DEFAULT;
    long oid = 0;

    public CtrlMatDispatchReceiveItem() {
    }

    public CtrlMatDispatchReceiveItem(HttpServletRequest request) {
        msgString = "";
        matDispatchReceiveItem = new MatDispatchReceiveItem();
        try {
            pstMatDispatchReceiveItem = new PstMatDispatchReceiveItem(0);
        } catch (Exception e) {
          ;
        }
        req = request;
        frmMatDispatchReceiveItem = new FrmMatDispatchReceiveItem(request, matDispatchReceiveItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMatDispatchReceiveItem.addError(frmMatDispatchReceiveItem.FRM_FIELD_DF_REC_ITEM_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MatDispatchReceiveItem getMatDispatchReceiveItem() {
        return matDispatchReceiveItem;
    }

    public FrmMatDispatchReceiveItem getForm() {
        return frmMatDispatchReceiveItem;
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

    public int action(int cmd, long oidMatDispatchReceiveItem, long oidDfRecGroup, long oidMatDispatch, long oidDfRecGroup1, int commandType) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidMatDispatchReceiveItem != 0) {
                    try {
                        matDispatchReceiveItem = PstMatDispatchReceiveItem.fetchExc(oidMatDispatchReceiveItem);
                    } catch (Exception exc) {
                        System.out.println("Exception : " + exc.toString());
                    }
                }

                frmMatDispatchReceiveItem.requestEntityObject(matDispatchReceiveItem);
                //Date date = ControlDate.getDateTime(FrmMatCosting.fieldNames[FrmMatCosting.FRM_FIELD_COSTING_DATE], req);
                //matCosting.setCostingDate(date);

                if (oidMatDispatchReceiveItem == 0) {
                    try {
                        //if(matDispatchReceiveItem.getDfRecGroupId()== 0){
                           // matDispatchReceiveItem.setDfRecGroupId(oidFactory.generateOID());
                       // }
                        //else{
                            //matDispatchReceiveItem.getDfRecGroupId();
                       // }
                         if(oidDfRecGroup== 0 && commandType == COMMAND_TYPE_GROUP){
                             matDispatchReceiveItem.setDfRecGroupId(oidFactory.generateOID());
                         }
                         else{
                             matDispatchReceiveItem.setDfRecGroupId(oidDfRecGroup);
                        }
                         if(commandType == COMMAND_TYPE_ITEM && oidDfRecGroup1!=0){
                            matDispatchReceiveItem.setDfRecGroupId(oidDfRecGroup1);
                         }
                         
                        //SessMatCosting sessCosting = new SessMatCosting();
                        //int maxCounter = sessCosting.getMaxCostingCounter(matCosting.getCostingDate(), matCosting);
                        //maxCounter = maxCounter + 1;
                        //matCosting.setCostingCodeCounter(maxCounter);
                        //matCosting.setCostingCode(sessCosting.generateCostingCode(matCosting));
                        //matCosting.setLastUpdate(new Date());   
                        this.oid = pstMatDispatchReceiveItem.insertExc(this.matDispatchReceiveItem);

                        /*
                         * For Update cost in Target
                         */
                       // long oidDfRecGroupCost = matDispatchReceiveItem.getDfRecGroupId();
                        //double qtyTarget = matDispatchReceiveItem.getTargetItem().getQty();
                        //double totalSource =PstMatDispatchItem.getTotalHppSourceTransfer(oidDfRecGroupCost);

                        
                        //double summaryExistingStockValue = SessMatDispatchReceive.getTotalHppExistingTarget(oidDfRecGroupCost);

                        //Vector updateHppTarget = SessMatDispatchReceive.updateHppTarget(totalSource, oidDfRecGroupCost);
                        //Vector updateHppTarget = SessMatDispatchReceive.updateHppTarget2(totalSource, oidDfRecGroupCost,summaryExistingStockValue );
                        //end of update HppTarget


                        //double qtyTarget = 0;
                        //double averagePrice = 0;
                        //double costTarget = 0;
                       // double costTargetNew = 0;
                        //double costTotal = 0;
                        //long oidDfRecItem = 0;

                      /* Vector vctGetQty = new Vector(1,1);
                        //vctGetQty = PstMatDispatchReceiveItem.getStockValueCurrentTarget(0,0,oidDfRecGroupCost);
                          vctGetQty = SessMatDispatchReceive.getStockValueCurrentTarget(0,0,oidDfRecGroupCost);
                        if( vctGetQty!=null &&  vctGetQty.size() > 0) {
                            for(int k=0;k<vctGetQty.size();k++){
                                MatDispatchReceiveItem dfRecItem = (MatDispatchReceiveItem)vctGetQty.get(k);
                                qtyTarget = dfRecItem.getTargetItem().getQty();
                                averagePrice = dfRecItem.getTargetItem().getMaterialTarget().getAveragePrice();
                                oidDfRecItem = dfRecItem.getTargetItem().getOID();
                                costTarget = totalSource / qtyTarget ;
                                dfRecItem.getTargetItem().setCost(costTarget);
                                costTotal = costTarget * qtyTarget;
                                dfRecItem.getTargetItem().setTotal(costTotal);
                                
                                PstMatDispatchReceiveItem.updateExc(dfRecItem);

                            }
                        }*/







                        //matDispatchReceiveItem.getTargetItem().setCost(total);
                       // System.out.println(totalSource);


                        //End of update cost Target

                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        //PstDocLogger.insertDataBo_toDocLogger(matCosting.getCostingCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matCosting.getLastUpdate(), matCosting.getRemark());
                        //--- end

                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                } else {
                    try {
                        //matCosting.setLastUpdate(new Date());
                             matDispatchReceiveItem.setOID(oidMatDispatchReceiveItem);
                             matDispatchReceiveItem.setDfRecGroupId(oidDfRecGroup1);
                        

                         this.oid = pstMatDispatchReceiveItem.updateExc(this.matDispatchReceiveItem);

                        /**
                         * gadnyana
                         * untuk insert ke doc logger
                         * jika tidak di perlukan uncomment
                         */
                        //PstDocLogger.updateDataBo_toDocLogger(matCosting.getCostingCode(), I_IJGeneral.DOC_TYPE_INVENTORY_ON_DF, matCosting.getLastUpdate(), matCosting.getRemark());
                        //--- end

                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                 /*
                         * For Update cost in Target
                         */
                       long oidDfRecGroupCost = matDispatchReceiveItem.getDfRecGroupId();
                        //double qtyTarget = matDispatchReceiveItem.getTargetItem().getQty();
                        double totalSource =PstMatDispatchItem.getTotalHppSourceTransfer(oidDfRecGroupCost);


                        double summaryExistingStockValue = SessMatDispatchReceive.getTotalHppExistingTarget(oidDfRecGroupCost);

                        //Vector updateHppTarget = SessMatDispatchReceive.updateHppTarget(totalSource, oidDfRecGroupCost);
                        Vector updateHppTarget = SessMatDispatchReceive.updateHppTarget2(totalSource, oidDfRecGroupCost,summaryExistingStockValue );
                        //end of update HppTarget

                break;

            case Command.EDIT:
                if (oidMatDispatchReceiveItem != 0) {
                    try {
                        matDispatchReceiveItem = PstMatDispatchReceiveItem.fetchExc(oidMatDispatchReceiveItem);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMatDispatchReceiveItem != 0) {
                    try {
                        matDispatchReceiveItem = PstMatDispatchReceiveItem.fetchExc(oidMatDispatchReceiveItem);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE :
                 //Untuk mendapatkan df_rec_item_id dan delete group
                if (oidMatDispatchReceiveItem == 0) {
                   Vector vect = PstMatDispatchReceiveItem.checkOID(oidDfRecGroup1);
                    if (vect != null && vect.size() > 0) {
                       for(int i=0; i<vect.size(); i++){
                        matDispatchReceiveItem = (MatDispatchReceiveItem) vect.get(i);
                        long oidMatDispatchReceiveItemGroup = matDispatchReceiveItem.getOID();
                        
                         try{
                            long oid = PstMatDispatchReceiveItem.deleteExc(oidMatDispatchReceiveItemGroup);
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
                    }
                   else {
                       oidMatDispatchReceiveItem = 0;
                   }
                }
                   //end of Delete Group

                else if(oidMatDispatchReceiveItem != 0) {
                     //Untuk mendaptkan oidReceiveMaterialItem
                     //String whereClause = PstMatDispatchReceiveItem.fieldNames[PstMatDispatchReceiveItem.FLD_DISPATCH_MATERIAL_ID] + "=" + oidMatDispatchReceiveItem;
                       // Vector vect = PstMatDispatchReceiveItem.list(0, 0, whereClause, "");
                      //  if (vect != null && vect.size() > 0) {
                           // for (int l = 0; l < vect.size(); l++) {
                                //MatDispatchReceiveItem matDispatchReceiveItem = (MatDispatchReceiveItem) vect.get(l);
                               // CtrlMatDispatchReceiveItem ctrlMatDpsRecItm = new CtrlMatDispatchReceiveItem();
                               // ctrlMatDpsRecItm.action(Command.DELETE, matDispatchReceiveItem.getOID(), oidMatDispatchReceiveItem);
                           // }
                       // }

                    try{


                        long oid = PstMatDispatchReceiveItem.deleteExc(oidMatDispatchReceiveItem);
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
                //for delete Group
                /*if (oidDfRecGroup1 != 0) {
                    try{
                        long oidGroup = PstMatDispatchReceiveItem.deleteGroup(oidDfRecGroup1);
			if(oidGroup!=0){
                                    msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                                    excCode = RSLT_OK;
			}else{
                                    msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                                    excCode = RSLT_FORM_INCOMPLETE;
                              }
                        //}catch(DBException dbexc){
				//excCode = dbexc.getErrorCode();
				//msgString = getSystemMessage(excCode);
			}catch(Exception exc){
				msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
			}

              }*/
                //end of delete Group
                break;
        }
        return rsCode;
    }
    
}
