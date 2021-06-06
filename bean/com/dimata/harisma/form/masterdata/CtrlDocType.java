/* Created on 	:  30 September 2011 [time] AM/PM
 *
 * @author  	:  Priska
 * @version  	:  [version]
 */
/**
 * *****************************************************************
 * Class Description : CtrlCompany Imput Parameters : [input parameter ...]
 * Output : [output ...]
 ******************************************************************
 */
package com.dimata.harisma.form.masterdata;

/**
 *
 * @author Priska
 */
/* java package */
/* project package */
//import com.dimata.harisma.db.*;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.system.entity.PstSystemProperty;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class CtrlDocType extends Control implements I_Language {

  public static int RSLT_OK = 0;
  public static int RSLT_UNKNOWN_ERROR = 1;
  public static int RSLT_EST_CODE_EXIST = 2;
  public static int RSLT_FORM_INCOMPLETE = 3;
  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  DocType cloneObj = null;
  public static String[][] resultText = {
    {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
    {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
  };
  private int start;
  private String msgString;
  private DocType docType;
  private PstDocType pstDocType;
  private FrmDocType frmDocType;
  int language = LANGUAGE_DEFAULT;

  public CtrlDocType(HttpServletRequest request) {
    msgString = "";
    logSysHistory = new LogSysHistory();
    history = new JSONObject();
    docType = new DocType();
    try {
      pstDocType = new PstDocType(0);
    } catch (Exception e) {
      ;
    }

    frmDocType = new FrmDocType(request, docType);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_JENIS_DOKUMEN]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
  }

  private String getSystemMessage(int msgCode) {
    switch (msgCode) {
      case I_DBExceptionInfo.MULTIPLE_ID:
        this.frmDocType.addError(frmDocType.FRM_FIELD_DOC_TYPE_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

  public DocType getdDocType() {
    return docType;
  }

  public FrmDocType getForm() {
    return frmDocType;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int action(int cmd, long oidDocType) {
    msgString = "";
    int excCode = I_DBExceptionInfo.NO_EXCEPTION;
    int rsCode = RSLT_OK;
    switch (cmd) {
      case Command.ADD:
        break;

      case Command.SAVE:
        if (oidDocType != 0) {
          try {
            docType = PstDocType.fetchExc(oidDocType);
            cloneObj = docType.clone();
          } catch (Exception exc) {
          }
        }

        frmDocType.requestEntityObject(docType);

        if (frmDocType.errorSize() > 0) {
          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
          return RSLT_FORM_INCOMPLETE;
        }

        if (docType.getOID() == 0) {
          try {
            long oid = pstDocType.insertExc(this.docType);

            logSysHistory.setLogUserAction("INSERT");
            history.combine(this.docType.historyNew());
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
            long oid = pstDocType.updateExc(this.docType);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(cloneObj.historyCompare(this.docType));
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }

        }
        break;

      case Command.EDIT:
        if (oidDocType != 0) {
          try {
            docType = PstDocType.fetchExc(oidDocType);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.ASK:
        if (oidDocType != 0) {
          try {
            docType = PstDocType.fetchExc(oidDocType);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.DELETE:
        if (oidDocType != 0) {
          try {
            this.cloneObj = PstDocType.fetchExc(oidDocType);
            long oid = PstDocType.deleteExc(oidDocType);
            logSysHistory.setLogUserAction("DELETE");
            history.combine(this.cloneObj.historyNew());
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
      logSysHistory.setLogDocumentId(oidDocType);
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }

    return rsCode;
  }
}
