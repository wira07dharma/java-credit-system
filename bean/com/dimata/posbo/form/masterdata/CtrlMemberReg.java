/*
 * Ctrl Name  		:  CtrlMemberReg.java
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

package com.dimata.posbo.form.masterdata;

import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.posbo.db.DBException;
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.posbo.session.masterdata.SessMemberReg;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.common.entity.contact.ContactClass;
import com.dimata.common.entity.contact.ContactClassAssign;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Vector;

public class CtrlMemberReg extends Control implements I_Language {
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
    private MemberReg memberReg;
    private PstMemberReg pstMemberReg;
    private FrmMemberReg frmMemberReg;
    int language = LANGUAGE_DEFAULT;

    public CtrlMemberReg(HttpServletRequest request) {
        msgString = "";
        memberReg = new MemberReg();
        try {
            pstMemberReg = new PstMemberReg(0);
        } catch (Exception e) {
            ;
        }
        frmMemberReg = new FrmMemberReg(request, memberReg);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_DBExceptionInfo.MULTIPLE_ID:
                this.frmMemberReg.addError(frmMemberReg.FRM_FIELD_CONTACT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public MemberReg getMemberReg() {
        return memberReg;
    }

    public FrmMemberReg getForm() {
        return frmMemberReg;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidMemberReg) {
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case Command.ADD:
                break;

            case Command.SAVE:
                MemberReg memReg = new MemberReg();
                if (oidMemberReg != 0) {
                    try {
                        memberReg = PstMemberReg.fetchExc(oidMemberReg);
                        memReg = PstMemberReg.fetchExc(oidMemberReg);
                    } catch (Exception exc) {
                    }
                }

                frmMemberReg.requestEntityObject(memberReg);

                if (frmMemberReg.errorSize() > 0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                memberReg.setMemberLastUpdate(new Date());
                if (memberReg.getOID() == 0) {
                    memberReg.setRegdate(new Date());
                    if (memberReg.getContactCode() == null || memberReg.getContactCode().length() == 0) {
                        String barcode = "";//PstMemberReg.genBarcode(memberReg);
                        memberReg.setMemberBarcode(barcode);
                        memberReg.setContactCode(barcode);
                        memberReg.setMemberCounter(PstMemberReg.setCounter(memberReg));
                    }

                    /*
                    String barcode = PstMemberReg.genBarcode(memberReg);
                    memberReg.setMemberBarcode(barcode);
                    memberReg.setContactCode(barcode);
                    memberReg.setMemberCounter(PstMemberReg.setCounter(memberReg));
                     */

                    try {
                        long oid = pstMemberReg.insertExc(this.memberReg);
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
                        memberReg.setRegdate(memReg.getRegdate());
                        memberReg.setMemberCounter(memReg.getMemberCounter());
                        memberReg.setMemberBarcode(memberReg.getContactCode());
                        memberReg.setProcessStatus(PstMemberReg.UPDATE);

                        //check validate member
                        String whHistory = PstMemberRegistrationHistory.fieldNames[PstMemberRegistrationHistory.FLD_MEMBER_ID] +
                                " = " + memberReg.getOID();
                        String orHistory = PstMemberRegistrationHistory.fieldNames[PstMemberRegistrationHistory.FLD_VALID_EXPIRED_DATE] +
                                " DESC ";
                        Vector listHistory = PstMemberRegistrationHistory.list(0, 1, whHistory, orHistory);
                        if (listHistory != null && listHistory.size() > 0) {
                            MemberRegistrationHistory memberHis = (MemberRegistrationHistory) listHistory.get(0);
                            if (memberHis.getValidExpiredDate().before(new Date())) {
                                memberReg.setMemberStatus(PstMemberReg.NOT_VALID);
                            }
                        }
                        long oid = pstMemberReg.updateExc(this.memberReg);

                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }

                }
                /* contact assign */
                PstContactClassAssign.deleteClassAssign(oidMemberReg);
                ContactClass cClass = PstMemberReg.getContactClass();
                ContactClassAssign cntClsAssign = new ContactClassAssign();
                cntClsAssign.setContactId(memberReg.getOID());
                cntClsAssign.setContactClassId(cClass.getOID());
                try {
                    PstContactClassAssign.insertExc(cntClsAssign);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("err at contactclass assign : " + e.toString());
                }

                break;
            case Command.EDIT:
                if (oidMemberReg != 0) {
                    try {
                        memberReg = PstMemberReg.fetchExc(oidMemberReg);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.UPDATE: // untuk update member point
                if (oidMemberReg != 0) {
                    try {
                        MemberPoin memberPoint = frmMemberReg.requestEntityObjectForUpdate(oidMemberReg);
                        PstMemberPoin.insertExc(memberPoint);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.ASK:
                if (oidMemberReg != 0) {
                    try {
                        memberReg = PstMemberReg.fetchExc(oidMemberReg);
                    } catch (DBException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case Command.DELETE:
                if (oidMemberReg != 0) {
                    try {
                        memberReg = PstMemberReg.fetchExc(oidMemberReg);
                        long oid = 0;
                        if (SessMemberReg.readyDataToDelete(oidMemberReg)) {
                            memberReg.setContactCode("" + memberReg.getOID());
                            memberReg.setMemberBarcode("" + memberReg.getOID());
                            memberReg.setProcessStatus(PstMemberReg.DELETE);
                            memberReg.setMemberLastUpdate(new Date());
                            oid = PstMemberReg.updateExc(memberReg);
                        }
                        if (oid != 0) {
                            PstMemberRegistrationHistory.deleteByIdMember(oid);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            frmMemberReg.addError(FrmMemberReg.FRM_FIELD_MEMBER_GROUP_ID, "");
                            msgString = "Hapus data gagal, data masih digunakan oleh data lain."; // FRMMessage.getMessage(FRMMessage.ERR_DELETED);
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

            default :

        }
        return excCode;
    }
}
