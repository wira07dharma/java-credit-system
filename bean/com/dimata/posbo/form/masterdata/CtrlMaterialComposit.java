package com.dimata.posbo.form.masterdata;

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
import com.dimata.posbo.entity.masterdata.*;

public class CtrlMaterialComposit extends Control implements I_Language {
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
    private MaterialComposit materialComposit;
    private PstMaterialComposit pstMaterialComposit;
    private FrmMaterialComposit frmMaterialComposit;
    int language = LANGUAGE_DEFAULT;
    
    public CtrlMaterialComposit(HttpServletRequest request){
        msgString = "";
        materialComposit = new MaterialComposit();
        try{
            pstMaterialComposit = new PstMaterialComposit(0);
        }catch(Exception e){;}
        frmMaterialComposit = new FrmMaterialComposit(request, materialComposit);
    }
    
    private String getSystemMessage(int msgCode){
        switch (msgCode){
            case I_DBExceptionInfo.MULTIPLE_ID :
                this.frmMaterialComposit.addError(frmMaterialComposit.FRM_FIELD_MATERIAL_ID, resultText[language][RSLT_EST_CODE_EXIST] );
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }
    
    private int getControlMsgId(int msgCode){
        switch (msgCode){
            case I_DBExceptionInfo.MULTIPLE_ID :
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }
    
    public int getLanguage(){ return language; }
    
    public void setLanguage(int language){ this.language = language; }
    
    public MaterialComposit getMaterialComposit() { return materialComposit; }
    
    public FrmMaterialComposit getForm() { return frmMaterialComposit; }
    
    public String getMessage(){ return msgString; }
    
    public int getStart() { return start; }
    
    public int action(int cmd , long oidMaterialComposit) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch(cmd) {
            case Command.ADD :
                break;
                
            case Command.SAVE :
                if(oidMaterialComposit != 0) {
                    try {
                        materialComposit = PstMaterialComposit.fetchExc(oidMaterialComposit);
                    }
                    catch(Exception exc) {
                    }
                }
                
                frmMaterialComposit.requestEntityObject(materialComposit);
                
                if(frmMaterialComposit.errorSize()>0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE ;
                }
                
                if(materialComposit.getOID()==0) {
                    try {
                        long oid = pstMaterialComposit.insertExc(this.materialComposit);
                    }
                    catch(DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    }
                    catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }
                else {
                    try {
                        long oid = pstMaterialComposit.updateExc(this.materialComposit);
                    }
                    catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }
                    catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }
                break;
                
            case Command.EDIT :
                if (oidMaterialComposit != 0) {
                    try {
                        materialComposit = PstMaterialComposit.fetchExc(oidMaterialComposit);
                    }
                    catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }
                    catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK :
                if (oidMaterialComposit != 0) {
                    try {
                        materialComposit = PstMaterialComposit.fetchExc(oidMaterialComposit);
                    }
                    catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }
                    catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE :
                if (oidMaterialComposit != 0) {
                    //System.out.println("OID <> 0" + oidMaterialComposit);
                    try {
                        long oid = PstMaterialComposit.deleteExc(oidMaterialComposit);
                        if(oid!=0) {
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        }
                        else {
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    }
                    catch(DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }
                    catch(Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            default :
                
        }
        return rsCode;
    }
}
