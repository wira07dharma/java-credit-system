/* Generated by Together */

package com.dimata.aiso.form.masterdata;

import javax.servlet.http.*;

import com.dimata.util.*;
import com.dimata.util.lang.I_Language;
import com.dimata.aiso.entity.masterdata.*;
import com.dimata.qdep.form.Control;

public class CtrlAktivaGroup extends Control implements I_Language {

    public static final int RSLT_OK = 0;
    public static final int RSLT_SAME = 1;
    public static final int RSLT_INCOMPLETE = 2;
    public static final int RSLT_EXIST = 3;
    public static final int RSLT_UNKNOWN = 4;
    public static String resultText[][] = {
        {"OK ...", "Rekening pertama sama dengan rekening kedua ...", "Form belum lengkap ...", "Account link sudah ada ...", "Kesalahan unknown ..."},
        {"OK ...", "First account same as the second one ...", "Form incomplete ...", "Link account already exist ...", "Unknown Error ..."}
    };


    private int start;
    private String msgString;
    private AktivaGroup aktiva;
    private PstAktivaGroup pstAktivaGroup;
    private FrmAktivaGroup frmAktivaGroup;
    private int language = LANGUAGE_DEFAULT;

    public CtrlAktivaGroup(HttpServletRequest request) {
        msgString = "";
        aktiva = new AktivaGroup();
        try {
            pstAktivaGroup = new PstAktivaGroup(0);
        } catch (Exception e) {
        }
        frmAktivaGroup = new FrmAktivaGroup(request, aktiva);
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public AktivaGroup getAktivaGroup() {
        return aktiva;
    }

    public FrmAktivaGroup getForm() {
        return frmAktivaGroup;
    }

    public String getMessage() {
        return msgString;
    }

    public int action(int cmd, long Oid) {
        this.start = start;
        int result = RSLT_OK;
        msgString = "";
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                if(Oid!=0){
                    try{
                        aktiva = PstAktivaGroup.fetchExc(Oid);
                    }catch(Exception e){}
                }
                frmAktivaGroup.requestEntityObject(aktiva);
                //aktiva.setOID();

                if (frmAktivaGroup.errorSize() > 0) {
                    msgString = resultText[language][RSLT_INCOMPLETE];
                    return RSLT_INCOMPLETE;
                }

                if (aktiva.getOID() == 0) {
                    try {
                        long oid = pstAktivaGroup.insertExc(this.aktiva);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                } else {
                    try {
                        long oid = pstAktivaGroup.updateExc(this.aktiva);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.EDIT:
                if (Oid != 0) {
                    try {
                        aktiva = (AktivaGroup) pstAktivaGroup.fetchExc(Oid);
                        System.out.println("aktiva ============ "+aktiva);
                    } catch (Exception exc) {
                        System.out.println("ADA DI CATCH ============ ");
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.ASK:
                if (Oid != 0) {
                    try {
                        aktiva = (AktivaGroup) pstAktivaGroup.fetchExc(Oid);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.DELETE:
                if (Oid != 0) {
                    PstAktivaGroup pstAktivaGroup = new PstAktivaGroup();
                    try {
                        long oid = pstAktivaGroup.deleteExc(Oid);
                        this.start = 0;
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            default:

        }
        return result;
    }
}
