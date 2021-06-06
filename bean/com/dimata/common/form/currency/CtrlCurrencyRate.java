/*
 * Ctrl Name  		:  CtrlCurrencyRate.java
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

package com.dimata.common.form.currency;

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
import com.dimata.common.db.*;

/* project package */
import com.dimata.common.entity.currency.*;

public class CtrlCurrencyRate extends Control implements I_Language {
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "", "Data tidak lengkap"},
        {"Succes", "Can not process", "", "Data incomplete"}
    };
    
    private int start;
    private String msgString;
    private CurrencyRate currencyRate;
    private PstCurrencyRate pstCurrencyRate;
    private FrmCurrencyRate frmCurrencyRate;
    int language = LANGUAGE_FOREIGN;
    
    public CtrlCurrencyRate(HttpServletRequest request){
        msgString = "";
        currencyRate = new CurrencyRate();
        try{
            pstCurrencyRate = new PstCurrencyRate(0);
        }catch(Exception e){;}
        frmCurrencyRate = new FrmCurrencyRate(request, currencyRate);
    }
    
    private String getSystemMessage(int msgCode){
        switch (msgCode){
            case I_DBExceptionInfo.MULTIPLE_ID :
                this.frmCurrencyRate.addError(frmCurrencyRate.FRM_FIELD_RATE_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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
    
    public CurrencyRate getCurrencyRate() { return currencyRate; }
    
    public FrmCurrencyRate getForm() { return frmCurrencyRate; }
    
    public String getMessage(){ return msgString; }
    
    public int getStart() { return start; }
    
    public int action(int cmd , long oidCurrencyRate){
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch(cmd){
            case Command.ADD :
                break;
                
            case Command.SAVE :
                if(oidCurrencyRate != 0){
                    try{
                        currencyRate = PstCurrencyRate.fetchExc(oidCurrencyRate);
                    }catch(Exception exc){
                    }
                }
                
                frmCurrencyRate.requestEntityObject(currencyRate);
                currencyRate.setDate(new Date());

                System.out.println("currencyRate.getDate() : "+currencyRate.getDate());
                System.out.println("currencyRate.getDate() : "+currencyRate.getDate());
                System.out.println("currencyRate.getDate() : "+currencyRate.getDate());
                
                if(frmCurrencyRate.errorSize()>0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE ;
                }
                
                if(currencyRate.getOID()==0){
                    try{
                        long oid = pstCurrencyRate.insertExc(this.currencyRate);
                    }catch(DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    }catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }else{
                    try {
                        long oid = pstCurrencyRate.updateExc(this.currencyRate);
                    }catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }
                break;
                
            case Command.EDIT :
                if (oidCurrencyRate != 0) {
                    try {
                        currencyRate = PstCurrencyRate.fetchExc(oidCurrencyRate);
                    } catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK :
                if (oidCurrencyRate != 0) {
                    try {
                        currencyRate = PstCurrencyRate.fetchExc(oidCurrencyRate);
                    } catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE :
                if (oidCurrencyRate != 0){
                    try{
                        long oid = PstCurrencyRate.deleteExc(oidCurrencyRate);
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
                break;                              
                
            default :
                
        }
        return rsCode;
    }
}
