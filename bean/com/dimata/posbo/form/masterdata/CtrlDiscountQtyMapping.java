/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.form.masterdata;

/**
 *
 * @author PT. Dimata
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
import com.dimata.posbo.db.*;
import com.dimata.posbo.entity.masterdata.*;

public class CtrlDiscountQtyMapping extends Control implements I_Language {

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
    private DiscountQtyMapping discountQtyMapping;
    private PstDiscountQtyMapping pstDiscountQtyMapping;
    private FrmDiscountQtyMapping frmDiscountQtyMapping;
    //private HttpServletRequest request2;
    private Vector DiscQtyMapping = new Vector(1, 1);
    int language = LANGUAGE_DEFAULT;

    public CtrlDiscountQtyMapping(HttpServletRequest request) {
        msgString = "";
        discountQtyMapping = new DiscountQtyMapping();
        try {
            pstDiscountQtyMapping = new PstDiscountQtyMapping(0);
        } catch (Exception e) {
            ;
        }
        frmDiscountQtyMapping = new FrmDiscountQtyMapping(request, discountQtyMapping);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmDiscountQtyMapping.addError(frmDiscountQtyMapping.FRM_FIELD_DISCOUNT_TYPE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public DiscountQtyMapping getDiscountQtyMapping() {
        return discountQtyMapping;
    }

    public FrmDiscountQtyMapping getForm() {
        return frmDiscountQtyMapping;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public void setDiscQtyMapping(Vector result) {
        this.DiscQtyMapping = result;
    }

    public Vector getDiscQtyMapping() {
        return this.DiscQtyMapping;
    }

    public int action(int cmd, long oidDiscountType, long oidCurrencyType, long oidLocation, long oidMaterial, HttpServletRequest request, int size) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                /*boolean checkOIDs = PstDiscountQtyMapping.checkOID(oidDiscountTypeId, oidCurrencyTypeId, oidLocationId, oidMaterialId);
                if(checkOIDs){
                try{
                discountQtyMapping = PstDiscountQtyMapping.fetchExc(oidDiscountTypeId, oidCurrencyTypeId, oidLocationId, oidMaterialId);
                }catch(Exception exc){
                }
                }

                frmDiscountQtyMapping.requestEntityObject(discountQtyMapping);
                discountQtyMapping.setDiscountTypeId(oidDiscountTypeId);
                discountQtyMapping.setCurrencyTypeId(oidCurrencyTypeId);
                discountQtyMapping.setLocationId(oidLocationId);
                discountQtyMapping.setMaterialId(oidMaterialId);*/
                // get vect Obj
                DiscQtyMapping = frmDiscountQtyMapping.requestEntityObject(size, request);
                setDiscQtyMapping(DiscQtyMapping);



                if (frmDiscountQtyMapping.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                String locs[] = request.getParameterValues(FrmDiscountQtyMapping.fieldNames[FrmDiscountQtyMapping.FRM_FIELD_LOCATION_ID]);

                //delete by ...
                if (locs != null) {
                    for (int ilx = 0; ilx < locs.length; ilx++) {
                        long lLocationId = 0;
                        try{
                            lLocationId = Long.parseLong(locs[ilx]);
                        } catch (Exception e){

                        }

                        try {
                            int delete = PstDiscountQtyMapping.deleteDiscountQtyMapping(oidDiscountType, oidCurrencyType, lLocationId, oidMaterial);

                        } catch (Exception exc) {
                        }

                        //loop .. insert
                        for (int idx = 0; idx < getDiscQtyMapping().size(); idx++) {
                            try {
                                DiscountQtyMapping qtymap = (DiscountQtyMapping) getDiscQtyMapping().get(idx);
                                //qtymap.setDiscountTypeId(oidDiscountType);
                                //qtymap.setCurrencyTypeId(oidCurrencyType);
                                qtymap.setLocationId(lLocationId);
                                //qtymap.setMaterialId(oidMaterial);
                                long oid = PstDiscountQtyMapping.insertExc(qtymap);
                                if (oid != 0) {
                                    msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                                    excCode = RSLT_OK;
                                } else {
                                    msgString = FRMMessage.getMessage(FRMMessage.ERR_SAVED);
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
                        }
                    }
                }
                Material material = new Material();
                //DiscountQtyMapping qtymap = new DiscountQtyMapping();
                //PstMaterial pstMaterial = new PstMaterial(oidMaterial);
                  try {
                    //PstMaterial pstMaterial = new PstMaterial(oidMaterial);
                      material = PstMaterial.fetchExc(oidMaterial);
                    } catch (Exception exc) {
                  }
                  //material.setOID(oidMaterial);
                   material.setLastUpdate(new Date());
                   //material.getUpdateDate() = now();

                 try {
                        //PstMaterial.updateExc(material);
                        PstMaterial.updateExcWithUpdateDate(material);
                        //pstMaterial.setDate(PstMaterial.FLD_UPDATE_DATE, material.getUpdateDate());
                      } catch (Exception err) {
                         //err.printStackTrace();
                         System.out.println("err di update to material " + err);
                      }
             
                       
            case Command.EDIT:
                break;

            case Command.ASK:
                break;

            case Command.DELETE:
                break;

            default:

        }
        return rsCode;
    }
}
