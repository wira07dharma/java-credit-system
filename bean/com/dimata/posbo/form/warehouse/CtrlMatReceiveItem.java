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
import com.dimata.posbo.db.*;
/* project package */
//import com.dimata.garment.db.*;
//import com.dimata.garment.entity.warehouse.*;
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.session.masterdata.SessPosting;
import com.dimata.posbo.session.warehouse.SessForwarderInfo;
import com.dimata.posbo.entity.masterdata.PstMatVendorPrice;
import com.dimata.posbo.entity.masterdata.MatVendorPrice;

public class CtrlMatReceiveItem extends Control implements I_Language {
    
    public static final int RSLT_OK = 0;
    public static final int RSLT_UNKNOWN_ERROR = 1;
    public static final int RSLT_MATERIAL_EXIST = 2;
    public static final int RSLT_FORM_INCOMPLETE = 3;
    public static final int RSLT_QTY_NULL = 4;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "Barang sudah ada", "Data tidak lengkap", "Jumlah barang tidak boleh nol ..."},
        {"Succes", "Can not process", "Material already exist ...", "Data incomplete", "Quantity may not zero ..."}
    };
    
    private int start;
    private String msgString;
    private MatReceiveItem matReceiveItem;
    private PstMatReceiveItem pstMatReceiveItem;
    private FrmMatReceiveItem frmMatReceiveItem;
    int language = LANGUAGE_DEFAULT;
    
    public CtrlMatReceiveItem() {
    }
    
    public CtrlMatReceiveItem(HttpServletRequest request) {
        msgString = "";
        matReceiveItem = new MatReceiveItem();
        try {
            pstMatReceiveItem = new PstMatReceiveItem(0);
        } catch (Exception e) {
            ;
        }
        frmMatReceiveItem = new FrmMatReceiveItem(request, matReceiveItem);
    }
    
    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                this.frmMatReceiveItem.addError(frmMatReceiveItem.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_MATERIAL_EXIST]);
                return resultText[language][RSLT_MATERIAL_EXIST];
            case RSLT_QTY_NULL:
                this.frmMatReceiveItem.addError(frmMatReceiveItem.FRM_FIELD_QTY, resultText[language][RSLT_QTY_NULL]);
                return resultText[language][RSLT_QTY_NULL];
            default :
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }
    
    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                return RSLT_MATERIAL_EXIST;
            case RSLT_QTY_NULL:
                return RSLT_QTY_NULL;
            default :
                return RSLT_UNKNOWN_ERROR;
        }
    }
    
    public int getLanguage() {
        return language;
    }
    
    public void setLanguage(int language) {
        this.language = language;
    }
    
    public MatReceiveItem getMatReceiveItem() {
        return matReceiveItem;
    }
    
    public FrmMatReceiveItem getForm() {
        return frmMatReceiveItem;
    }
    
    public String getMessage() {
        return msgString;
    }
    
    public int getStart() {
        return start;
    }
    
    
    /**
     * @param cmd
     * @param oidMatReceiveItem
     * @param oidMatReceive
     * @return
     * @created <CODE>on Jan 30, 2004</CODE>
     * @created <CODE>by Gedhy</CODE>
     */
    synchronized public int action(int cmd, long oidMatReceiveItem, long oidMatReceive) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;
                
            case Command.SAVE:
                double qtymax = 0;
                if (oidMatReceiveItem != 0) {
                    try {
                        matReceiveItem = PstMatReceiveItem.fetchExc(oidMatReceiveItem);
                        qtymax = matReceiveItem.getQty();
                    } catch (Exception exc) {
                    }
                }
                frmMatReceiveItem.requestEntityObject(matReceiveItem);
                matReceiveItem.setResidueQty(matReceiveItem.getQty());
                matReceiveItem.setReceiveMaterialId(oidMatReceive);
                
                // check if current material already exist in orderMaterial
                if (matReceiveItem.getOID() == 0 && PstMatReceiveItem.materialExist(matReceiveItem.getMaterialId(), oidMatReceive)) {
                    msgString = getSystemMessage(RSLT_MATERIAL_EXIST);
                    return getControlMsgId(RSLT_MATERIAL_EXIST);
                }
                
                /**
                 * check if current material already exist in orderMaterial
                 * @created <CODE>by Gedhy</CODE>
                 */
                if (matReceiveItem.getQty() == 0) {
                    msgString = getSystemMessage(RSLT_QTY_NULL);
                    return getControlMsgId(RSLT_QTY_NULL);
                }
                
                if (frmMatReceiveItem.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                
                // untuk cek document receive
                MatReceive matReceive = new MatReceive();
                try {
                    matReceive = PstMatReceive.fetchExc(oidMatReceive);
                } catch (Exception e) {
                }
                
                switch (matReceive.getReceiveSource()) {
                    /**
                     * kalo tipe receive adalah dari return toko
                     * proses ini dilakukan di WAREHOUSE
                     * @created <CODE>by Edhy</CODE>
                     */
                    case PstMatReceive.SOURCE_FROM_RETURN:
                        MatReturnItem matReturnItem = PstMatReturnItem.getObjectReturnItem(matReceiveItem.getMaterialId(), matReceive.getReturnMaterialId());
                        
                        qtymax = qtymax + matReturnItem.getResidueQty();
                        System.out.println("===>>> SISA QTY : " + qtymax);
                        if (matReceiveItem.getQty() > qtymax) {
                            frmMatReceiveItem.addError(0, "");
                            msgString = "maksimal qty adalah =" + qtymax;
                            return RSLT_FORM_INCOMPLETE;
                        }
                        
                        if (matReceiveItem.getOID() == 0) {
                            try {
                                oidMatReceiveItem = pstMatReceiveItem.insertExc(this.matReceiveItem);
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
                                oidMatReceiveItem = pstMatReceiveItem.updateExc(this.matReceiveItem);
                            } catch (DBException dbexc) {
                                excCode = dbexc.getErrorCode();
                                msgString = getSystemMessage(excCode);
                            } catch (Exception exc) {
                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                            }
                            
                        }
                        
                        matReturnItem.setResidueQty(qtymax - matReceiveItem.getQty());
                        try {
                            PstMatReturnItem.updateExc(matReturnItem);
                        } catch (Exception e) {
                        }
                        
                        // update transfer status
                        PstMatReturn.processUpdate(matReceive.getReturnMaterialId());
                        
                        // proses serial code
                        PstReceiveStockCode.getInsertSerialFromReturn(oidMatReceiveItem,matReceive.getReturnMaterialId(),matReceiveItem.getMaterialId());
                        break;
                        
                        /**
                         * kalo tipe receive adalah dari dispatch warehouse
                         * proses ini dilakukan di STORE
                         * @created <CODE>by Edhy</CODE>
                         */
                    case PstMatReceive.SOURCE_FROM_DISPATCH:
                        MatDispatchItem matDispatchItem = PstMatDispatchItem.getObjectDispatchItem(matReceiveItem.getMaterialId(), matReceive.getDispatchMaterialId());
                        
                        qtymax = qtymax + matDispatchItem.getResidueQty();
                        System.out.println("===>>> SISA QTY : " + qtymax);
                        if (matReceiveItem.getQty() > qtymax) {
                            frmMatReceiveItem.addError(0, "");
                            msgString = "maksimal qty adalah =" + qtymax;
                            return RSLT_FORM_INCOMPLETE;
                        }
                        
                        if (matReceiveItem.getOID() == 0) {
                            try {
                                long oid = pstMatReceiveItem.insertExc(this.matReceiveItem);
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
                                long oid = pstMatReceiveItem.updateExc(this.matReceiveItem);
                            } catch (DBException dbexc) {
                                excCode = dbexc.getErrorCode();
                                msgString = getSystemMessage(excCode);
                            } catch (Exception exc) {
                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                            }
                            
                        }
                        
                        matDispatchItem.setResidueQty(qtymax - matReceiveItem.getQty());
                        try {
                            PstMatDispatchItem.updateExc(matDispatchItem);
                        } catch (Exception e) {
                        }
                        
                        // update transfer status
                        PstMatDispatch.processUpdate(matReceive.getDispatchMaterialId());
                        
                        break;
                        
                        
                    default :
                        if (matReceiveItem.getOID() == 0) {
                            try {
                                long oid = pstMatReceiveItem.insertExc(this.matReceiveItem);
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
                                long oid = pstMatReceiveItem.updateExc(this.matReceiveItem);
                            } catch (DBException dbexc) {
                                excCode = dbexc.getErrorCode();
                                msgString = getSystemMessage(excCode);
                            } catch (Exception exc) {
                                msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                            }
                            
                        }
                        // set vendor price untuk  barang ini
                        try{
                                double newCost = matReceiveItem.getCost();
                                double lastDisc = matReceiveItem.getDiscount();
                                double lastDisc2 = matReceiveItem.getDiscount2();
                                double lastDiscNom = matReceiveItem.getDiscNominal();
                                double newForwarderCost = matReceiveItem.getForwarderCost();

                                MatVendorPrice matVdrPrc = new MatVendorPrice();
                                matVdrPrc.setVendorId(matReceive.getSupplierId());
                                matVdrPrc.setPriceCurrency(matReceive.getCurrencyId());
                                matVdrPrc.setMaterialId(matReceiveItem.getMaterialId());
                                matVdrPrc.setBuyingUnitId(matReceiveItem.getUnitId());
                                matVdrPrc.setOrgBuyingPrice(matReceiveItem.getCost());
                                //matVdrPrc.setCurrBuyingPrice(matReceiveItem.getCost());
                                matVdrPrc.setLastDiscount(matReceiveItem.getDiscNominal());

                                //set Discount1 & Discount2, ForwarderCost
                                matVdrPrc.setLastDiscount1(lastDisc);
                                matVdrPrc.setLastDiscount2(lastDisc2);
                                matVdrPrc.setLastCostCargo(newForwarderCost);

                                //calculate hpp & discount
                                // By Mirahu 25 Februari2011
                                double totalDiscount = newCost * lastDisc/100;
                                double totalMinus = newCost - totalDiscount;
                                double totalDiscount2 = totalMinus * lastDisc2/100;
                                double totalCost = (totalMinus - totalDiscount2)-lastDiscNom;
                                double totalCostAll = totalCost + newForwarderCost;

                                matVdrPrc.setCurrBuyingPrice(totalCostAll);

                                        
                                PstMatVendorPrice.insertUpdateExc(matVdrPrc);                                        
                        } catch(Exception exc){
                            System.out.println(" Exc. in update/insert vendor price ");
                        }
                        
                        
                        /** set total cost pada forwarder info dengan value terkini! */
                        try {System.out.println("oidMatReceiveItem >>> "+this.matReceiveItem.getReceiveMaterialId());
                            String whereClause = ""+PstForwarderInfo.fieldNames[PstForwarderInfo.FLD_RECEIVE_ID]+"="+this.matReceiveItem.getReceiveMaterialId();
                            Vector vctListFi = PstForwarderInfo.list(0, 0, whereClause, "");
                            ForwarderInfo forwarderInfo = new ForwarderInfo();
                            for(int j=0; j<vctListFi.size(); j++) {
                                forwarderInfo = (ForwarderInfo)vctListFi.get(j);
                                forwarderInfo.setTotalCost(SessForwarderInfo.getTotalCost(this.matReceiveItem.getReceiveMaterialId()));
                                System.out.println("totalCost >> "+forwarderInfo.getTotalCost());
                                long oid = PstForwarderInfo.updateExc(forwarderInfo);
                            }
                        }
                        catch(Exception e) {
                            System.out.println("Exc in update total_cost, forwarder_info >>> "+e.toString());
                        }
                        
                        break;
                }
                
                break;
                
            case Command.EDIT:
                if (oidMatReceiveItem != 0) {
                    try {
                        matReceiveItem = PstMatReceiveItem.fetchExc(oidMatReceiveItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK:
                if (oidMatReceiveItem != 0) {
                    try {
                        matReceiveItem = PstMatReceiveItem.fetchExc(oidMatReceiveItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE:
                if (oidMatReceiveItem != 0) {
                    
                    MatReceive matRec = new MatReceive();
                    MatReceiveItem matReceiveItem = new MatReceiveItem();
                    try {
                        matRec = PstMatReceive.fetchExc(oidMatReceive);
                        matReceiveItem = PstMatReceiveItem.fetchExc(oidMatReceiveItem);
                    } catch (Exception e) {
                        System.out.println("Err when fetch matReceive and matReceiveItem : " + e.toString());
                    }
                    qtymax = matReceiveItem.getQty();
                    
                    try {
                        // untuk penghapusan code di stock code
                        SessPosting.deleteUpdateStockCode(0,0,oidMatReceiveItem,SessPosting.DOC_TYPE_RECEIVE);
                        long oid = PstMatReceiveItem.deleteExc(oidMatReceiveItem);
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
                    
                    switch (matRec.getReceiveSource()) {
                        
                        /**
                         * kalo tipe receive adalah dari return toko
                         * proses ini dilakukan di WAREHOUSE
                         * @created <CODE>by Edhy</CODE>
                         */
                        case PstMatReceive.SOURCE_FROM_RETURN:
                            MatReturnItem matReturnItem = new MatReturnItem();
                            try {
                                matReturnItem = PstMatReturnItem.getObjectReturnItem(matReceiveItem.getMaterialId(), matRec.getReturnMaterialId());
                            } catch (Exception e) {
                                System.out.println("Err when fetch matReturnItem : " + e.toString());
                            }
                            
                            qtymax = qtymax + matReturnItem.getResidueQty();
                            matReturnItem.setResidueQty(qtymax);
                            
                            try {
                                PstMatReturnItem.updateExc(matReturnItem);
                            } catch (Exception e) {
                                System.out.println("Err when update MatReturnItem : " + e.toString());
                            }
                            
                            // update status transfer
                            PstMatReturn.processUpdate(matRec.getReturnMaterialId());
                            
                            break;
                            
                            /**
                             * kalo tipe receive adalah dari dispatch warehouse
                             * proses ini dilakukan di STORE
                             * @created <CODE>by Edhy</CODE>
                             */
                        case PstMatReceive.SOURCE_FROM_DISPATCH:
                            MatDispatchItem matDispatchItem = new MatDispatchItem();
                            try {
                                matDispatchItem = PstMatDispatchItem.getObjectDispatchItem(matReceiveItem.getMaterialId(), matRec.getDispatchMaterialId());
                            } catch (Exception e) {
                                System.out.println("Err when fetch MatDispatchItem : " + e.toString());
                            }
                            
                            qtymax = qtymax + matDispatchItem.getResidueQty();
                            matDispatchItem.setResidueQty(qtymax);
                            
                            try {
                                PstMatDispatchItem.updateExc(matDispatchItem);
                            } catch (Exception e) {
                                System.out.println("Err when update MatDispatchItem : " + e.toString());
                            }
                            
                            // update status transfer
                            PstMatDispatch.processUpdate(matRec.getDispatchMaterialId());
                            
                            break;
                    }
                }
                
                break;
                
            default :
                break;
                
        }
        return rsCode;
    }
}
