/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.kredit;

/**
 *
 * @author WiraDharma
 */
import javax.servlet.http.*;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.db.*;
import com.dimata.sedana.entity.kredit.DokumenPinjaman;
import com.dimata.sedana.entity.kredit.PstDokumenPinjaman;

/*
Description : Controll DokumenPinjaman
Date : Sun Dec 01 2019
Author : WiraDharna
 */
public class CtrlDokumenPinjaman extends Control implements I_Language {

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
    private DokumenPinjaman entDokumenPinjaman;
    private PstDokumenPinjaman pstDokumenPinjaman;
    private FrmDokumenPinjaman frmDokumenPinjaman;
    int language = LANGUAGE_DEFAULT;

    public CtrlDokumenPinjaman(HttpServletRequest request) {
        msgString = "";
        entDokumenPinjaman = new DokumenPinjaman();
        try {
            pstDokumenPinjaman = new PstDokumenPinjaman(0);
        } catch (Exception e) {;
        }
        frmDokumenPinjaman = new FrmDokumenPinjaman(request, entDokumenPinjaman);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmDokumenPinjaman.addError(frmDokumenPinjaman.FRM_FIELD_DOKUMEN_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public DokumenPinjaman getDokumenPinjaman() {
        return entDokumenPinjaman;
    }

    public FrmDokumenPinjaman getForm() {
        return frmDokumenPinjaman;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidDokumenPinjaman) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if (oidDokumenPinjaman != 0) {
                    try {
                        entDokumenPinjaman = PstDokumenPinjaman.fetchExc(oidDokumenPinjaman);
                    } catch (Exception exc) {
                    }
                }

                frmDokumenPinjaman.requestEntityObject(entDokumenPinjaman);

                if (frmDokumenPinjaman.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (entDokumenPinjaman.getOID() == 0) {
                    try {
                        long oid = pstDokumenPinjaman.insertExc(this.entDokumenPinjaman);
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
                        long oid = pstDokumenPinjaman.updateExc(this.entDokumenPinjaman);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case Command.EDIT:
                if (oidDokumenPinjaman != 0) {
                    try {
                        entDokumenPinjaman = PstDokumenPinjaman.fetchExc(oidDokumenPinjaman);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidDokumenPinjaman != 0) {
                    try {
                        entDokumenPinjaman = PstDokumenPinjaman.fetchExc(oidDokumenPinjaman);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidDokumenPinjaman != 0) {
                    try {
                        long oid = PstDokumenPinjaman.deleteExc(oidDokumenPinjaman);
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

            default:

        }
        return rsCode;
    }
}
