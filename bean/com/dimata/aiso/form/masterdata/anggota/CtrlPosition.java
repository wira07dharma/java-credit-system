/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.anggota;

import com.dimata.aiso.entity.masterdata.anggota.Position;
import com.dimata.aiso.entity.masterdata.anggota.PstPosition;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.qdep.system.I_DBExceptionInfo;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author nuharta
 */
public class CtrlPosition extends Control implements I_Language {

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

  private Position position;

  private PstPosition pst;

  private FrmPosition frm;

  int language = LANGUAGE_DEFAULT;

  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  Position cloneObj = new Position();

  public CtrlPosition(HttpServletRequest request) {

    msgString = "";

    position = new Position();

    try {

      pst = new PstPosition(0);

    } catch (Exception e) {;
    }

    frm = new FrmPosition(request, position);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_POSISI]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
  }

  private String getSystemMessage(int msgCode) {

    switch (msgCode) {

      case I_DBExceptionInfo.MULTIPLE_ID:

        this.frm.addError(FrmPosition.FRM_FIELD_POSITION_ID, resultText[language][RSLT_EST_CODE_EXIST]);

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

  public Position getposition() {
    return position;
  }

  public FrmPosition getForm() {
    return frm;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int action(int cmd, long oidPosition) {

    msgString = "";

    int excCode = I_DBExceptionInfo.NO_EXCEPTION;

    int rsCode = RSLT_OK;

    switch (cmd) {

      case Command.ADD:

        break;

      case Command.SAVE:

        if (oidPosition != 0) {

          try {

            position = PstPosition.fetchExc(oidPosition);
            cloneObj = position == null ? cloneObj : position.clone();
          } catch (Exception exc) {

          }

        }

        frm.requestEntityObject(position);

        if (frm.errorSize() > 0) {

          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);

          return RSLT_FORM_INCOMPLETE;

        }

        if (position.getOID() == 0) {

          try {

            long oid = pst.insertExc(this.position);
            logSysHistory.setLogUserAction("INSERT");
            frm.requestEntityObject(cloneObj);
            history.combine(this.cloneObj.historyNew());
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

            long oid = pst.updateExc(this.position);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(cloneObj.historyCompare(this.position));

          } catch (DBException dbexc) {

            excCode = dbexc.getErrorCode();

            msgString = getSystemMessage(excCode);

          } catch (Exception exc) {

            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);

          }

        }

        break;

      case Command.EDIT:

        if (oidPosition != 0) {

          try {

            position = PstPosition.fetchExc(oidPosition);

          } catch (Exception exc) {

            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);

          }

        }

        break;

      case Command.ASK:

        if (oidPosition != 0) {

          try {

            position = PstPosition.fetchExc(oidPosition);

          } catch (Exception exc) {

            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);

          }

        }

        break;

      case Command.DELETE:

        if (oidPosition != 0) {

          try {
            this.cloneObj = pst.fetchExc(oidPosition);
            long oid = PstPosition.deleteExc(oidPosition);
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
      logSysHistory.setLogDocumentId(oidPosition);
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }
    
    return rsCode;

  }
}
