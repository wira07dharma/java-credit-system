package com.dimata.posbo.form.warehouse;

import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;

import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.posbo.session.masterdata.SessPosting;
import com.dimata.posbo.entity.warehouse.PstMatCostingItem;
import com.dimata.posbo.entity.warehouse.MatCostingItem;
import com.dimata.posbo.db.DBException;

import javax.servlet.http.HttpServletRequest;


public class CtrlMatCostingItem extends Control implements I_Language {

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
    private MatCostingItem matCostingItem;
    private PstMatCostingItem pstMatCostingItem;
    private FrmMatCostingItem frmMatCostingItem;
    int language = LANGUAGE_DEFAULT;

    public CtrlMatCostingItem() {
    }

    public CtrlMatCostingItem(HttpServletRequest request) {
        msgString = "";
        matCostingItem = new MatCostingItem();
        try {
            pstMatCostingItem = new PstMatCostingItem(0);
        } catch (Exception e) {
        }
        frmMatCostingItem = new FrmMatCostingItem(request, matCostingItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case RSLT_MATERIAL_EXIST:
                this.frmMatCostingItem.addError(frmMatCostingItem.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_MATERIAL_EXIST]);
                return resultText[language][RSLT_MATERIAL_EXIST];
            case RSLT_QTY_NULL:
                this.frmMatCostingItem.addError(frmMatCostingItem.FRM_FIELD_QTY, resultText[language][RSLT_QTY_NULL]);
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

    public MatCostingItem getMatCostingItem() {
        return matCostingItem;
    }

    public FrmMatCostingItem getForm() {
        return frmMatCostingItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }


    /**
     *
     * @param cmd
     * @param <CODE>oidMatCostingItem</CODE>
     * @param oidMatDispatch
     * @return
     */
    synchronized public int action(int cmd, long oidMatCostingItem, long oidMatCosting) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                double qtymax = 0;
                if (oidMatCostingItem != 0) {
                    try {
                        matCostingItem = PstMatCostingItem.fetchExc(oidMatCostingItem);
                        qtymax = matCostingItem.getQty();
                    } catch (Exception exc) {
                    }
                }

                frmMatCostingItem.requestEntityObject(matCostingItem);
                matCostingItem.setResidueQty(matCostingItem.getQty());
                matCostingItem.setCostingMaterialId(oidMatCosting);

                if (frmMatCostingItem.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }


                /**
                 * check if current material already exist in orderMaterial
                 * @created <CODE>by Gedhy</CODE>
                 */
                if (matCostingItem.getQty() == 0) {
                    msgString = getSystemMessage(RSLT_QTY_NULL);
                    return getControlMsgId(RSLT_QTY_NULL);
                }

                /**
                 * ini di pakai untuk mencari objeck dispatch
                 * dan di pakai untuk mencari object receive item
                 * untuk mengetahui nilai sisa yang sebenarnya.
                 */
                /* MatCosting matCosting = new MatCosting();
                 try {
                     matCosting = PstMatCosting.fetchExc(oidMatCosting);
                 } catch (Exception e) {
                 }
                 MatReceiveItem matReceiveItem = PstMatReceiveItem.getObjectReceiveItem(matCosting.getInvoiceSupplier(), 0, matCostingItem.getMaterialId());

                 qtymax = qtymax + matReceiveItem.getResidueQty();
                 System.out.println("===>>> SISA QTY : " + qtymax);

                 // jika quantity yg akan didispatch melebihi maximum yg ada, maka return error
                 if (matCostingItem.getQty() > qtymax) {
                     frmMatCostingItem.addError(0, "");
                     msgString = "maksimal qty adalah =" + qtymax;
                     return RSLT_FORM_INCOMPLETE;
                 } */

                /**
                 * jika quantity yg akan didispctch memenuhi syarat, maka proses seperti biasa
                 * INSERT atau UPDATE sesuai dengan nilai OID dispstch
                 */
                if (matCostingItem.getOID() == 0) {
                    try {
                        long oid = pstMatCostingItem.insertExc(this.matCostingItem);
                    } catch ( DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                } else {
                    try {
                        long oid = pstMatCostingItem.updateExc(this.matCostingItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                       return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                }

                /**
                 * Jika proses INSERT atau UPDATE berhasil (no exception), maka lakukan proses
                 * peng-update-an quantity sisa di receive berdasarkan NO INVOICE yg ada
                 */
                /*matReceiveItem.setResidueQty(qtymax - matCostingItem.getQty());
                try {
                    PstMatReceiveItem.updateExc(matReceiveItem);
                } catch (Exception e) {
                }

                // update transfer status
                PstMatReceive.processUpdate(matReceiveItem.getReceiveMaterialId());*/

                break;

            case Command.EDIT:
                if (oidMatCostingItem != 0) {
                    try {
                        matCostingItem = PstMatCostingItem.fetchExc(oidMatCostingItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMatCostingItem != 0) {
                    try {
                        matCostingItem = PstMatCostingItem.fetchExc(oidMatCostingItem);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMatCostingItem != 0) {
                    /**
                     * Proses peng-update-an quantity sisa di dokumen receive kalau proses
                     * delete pada dokumen dispatch ini berhasil
                     */
                    MatCostingItem matCostingItem = new MatCostingItem();
                    try {
                        matCostingItem = PstMatCostingItem.fetchExc(oidMatCostingItem);
                    } catch (Exception e) {
                        System.out.println("Err when fetch matCostingItem " + e.toString());
                    }

                    /*qtymax = matCostingItem.getQty();

                    matCosting = new MatCosting();
                    try {
                        matCosting = PstMatCosting.fetchExc(oidMatCosting);
                    } catch (Exception e) {
                    }
                    matReceiveItem = PstMatReceiveItem.getObjectReceiveItem(matCosting.getInvoiceSupplier(), 0, matCostingItem.getMaterialId());
                    qtymax = qtymax + matReceiveItem.getResidueQty();*/

                    try {
                        SessPosting.deleteUpdateStockCode(0, 0, oidMatCostingItem, SessPosting.DOC_TYPE_COSTING);
                        long oid = PstMatCostingItem.deleteExc(oidMatCostingItem);
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
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }

                    // update receive item
                    /*matReceiveItem.setResidueQty(qtymax);
                    try {
                        PstMatReceiveItem.updateExc(matReceiveItem);
                    } catch (Exception e) {
                    }

                    // update transfer status
                    PstMatReceive.processUpdate(matReceiveItem.getReceiveMaterialId());*/
                }
                break;

            default :
                break;
        }
        return rsCode;
    }
}
