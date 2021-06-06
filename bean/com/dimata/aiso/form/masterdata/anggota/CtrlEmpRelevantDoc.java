/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.anggota;

import com.dimata.aiso.entity.masterdata.anggota.EmpRelevantDoc;
import com.dimata.aiso.entity.masterdata.anggota.PstEmpRelevantDoc;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dedy_blinda
 */
public class CtrlEmpRelevantDoc extends Control implements I_Language {

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
  private EmpRelevantDoc ent;
  private PstEmpRelevantDoc pst;
  private FrmEmpRelevantDoc frm;
  int language = LANGUAGE_DEFAULT;

  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  EmpRelevantDoc tmpEnt = new EmpRelevantDoc();

  /**
   * Creates a new instance of CtlEmpRelevantDoc
   */
  public CtrlEmpRelevantDoc(HttpServletRequest request) {
    msgString = "";
    ent = new EmpRelevantDoc();
    try {
      pst = new PstEmpRelevantDoc(0);
    } catch (Exception e) {;
    }
    frm = new FrmEmpRelevantDoc(request, ent);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_RELEVANT_DOC_GROUP]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));

  }

  private String getSystemMessage(int msgCode) {
    switch (msgCode) {
      case I_DBExceptionInfo.MULTIPLE_ID:
        this.frm.addError(frm.FRM_FIELD_DOC_RELEVANT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

  public EmpRelevantDoc getEmpRelevantDoc() {
    return ent;
  }

  public FrmEmpRelevantDoc getForm() {
    return frm;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int action(int cmd, long oidEmpRelevantDoc, long oidAnggota) {
    msgString = "";

    //ystem.out.println("cmd...."+cmd);
    int excCode = I_DBExceptionInfo.NO_EXCEPTION;
    int rsCode = RSLT_OK;

    switch (cmd) {
      case Command.ADD:
        break;

      case Command.SAVE:
        EmpRelevantDoc prevEmpDoc = null;
        if (oidEmpRelevantDoc != 0) {
          try {
            ent = PstEmpRelevantDoc.fetchExc(oidEmpRelevantDoc);
            tmpEnt = ent == null ? tmpEnt : ent.clone();
          } catch (Exception exc) {
          }
        }

        ent.setOID(oidEmpRelevantDoc);

        frm.requestEntityObject(ent);

        ent.setAnggotaId(oidAnggota);

        if (this.ent.getDocTitle() == "" || this.ent == null) {
          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
          return RSLT_FORM_INCOMPLETE;
        }
        //System.out.println("frmEmpRelevantDoc.errorSize()"+frmEmpRelevantDoc.errorSize());

        /*if(frmEmpRelevantDoc.errorSize()>0) {
         msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
         return RSLT_FORM_INCOMPLETE ;
         }*/
        if (ent.getOID() == 0) {
          try {
            oidEmpRelevantDoc = pst.insertExc(this.ent);
            msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
            logSysHistory.setLogUserAction("INSERT");
            history.combine(this.ent.historyNew());
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
            if (this.ent.getDocTitle() == "" || this.ent == null) {
              msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
              return RSLT_FORM_INCOMPLETE;
            }
            oidEmpRelevantDoc = pst.updateExc(this.ent);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(tmpEnt.historyCompare(this.ent));
            msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);

          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }

        }
        break;

      case Command.EDIT:
        if (oidEmpRelevantDoc != 0) {
          try {
            ent = PstEmpRelevantDoc.fetchExc(oidEmpRelevantDoc);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.ASK:
        if (oidEmpRelevantDoc != 0) {
          try {
            ent = PstEmpRelevantDoc.fetchExc(oidEmpRelevantDoc);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.DELETE:
        if (oidEmpRelevantDoc != 0) {
          try {
            this.tmpEnt = pst.fetchExc(oidEmpRelevantDoc);
            long oid = PstEmpRelevantDoc.deleteExc(oidEmpRelevantDoc);
            logSysHistory.setLogUserAction("DELETE");
            history.combine(this.tmpEnt.historyNew());
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
    if (logSysHistory != null
            && rsCode == RSLT_OK
            && logSysHistory.getLogUserAction() != null
            && !logSysHistory.getLogUserAction().equals("")) {
      logSysHistory.setLogDocumentId(oidEmpRelevantDoc);
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }
    return rsCode;
  }
}
