/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.masterdata;

/**
 *
 * @author Regen
 */
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.gui.jsp.ControlDate;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.entity.masterdata.PstSedanaShift;
import com.dimata.sedana.entity.masterdata.SedanaShift;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import java.util.Date;
import javax.servlet.http.*;

public class CtrlSedanaShift extends Control implements I_Language {

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
  private SedanaShift obj;
  private PstSedanaShift pst;
  private FrmSedanaShift frm;
  int language = LANGUAGE_DEFAULT;

  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  SedanaShift cloneObj = new SedanaShift();

  public CtrlSedanaShift(HttpServletRequest request) {
    msgString = "";
    obj = new SedanaShift();
    try {
      pst = new PstSedanaShift(0);
    } catch (Exception e) {;
    }
    frm = new FrmSedanaShift(request, obj);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_SHIFT]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
  }

  private String getSystemMessage(int msgCode) {
    switch (msgCode) {
      case I_DBExceptionInfo.MULTIPLE_ID:
        this.frm.addError(frm.FRM_FIELD_SHIFT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

  public SedanaShift getSedanaShift() {
    return obj;
  }

  public FrmSedanaShift getForm() {
    return frm;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int action(int cmd, long oidSedanaShift, HttpServletRequest request) {
    msgString = "";
    int excCode = I_DBExceptionInfo.NO_EXCEPTION;
    int rsCode = RSLT_OK;
    switch (cmd) {
      case Command.ADD:
        break;

      case Command.SAVE:
        if (oidSedanaShift != 0) {
          try {
            obj = PstSedanaShift.fetchExc(oidSedanaShift);
            cloneObj = obj == null ? cloneObj : obj.clone();
          } catch (Exception exc) {
          }
        }
        Date startShift = ControlDate.getTime(frm.fieldNames[frm.FRM_FIELD_START_TIME], request);
        Date endShift = ControlDate.getTime(frm.fieldNames[frm.FRM_FIELD_END_TIME], request);
        frm.requestEntityObject(obj);

        obj.setStartTime(startShift);
        obj.setEndTime(endShift);

        if (frm.errorSize() > 0) {
          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
          return RSLT_FORM_INCOMPLETE;
        }

        if (obj.getOID() == 0) {
          try {
            long oid = pst.insertExc(this.obj);
            logSysHistory.setLogUserAction("INSERT");
            history.combine(this.obj.historyNew());
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
            long oid = pst.updateExc(this.obj);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(cloneObj.historyCompare(this.obj));
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }

        }
        break;

      case Command.EDIT:
        if (oidSedanaShift != 0) {
          try {
            obj = PstSedanaShift.fetchExc(oidSedanaShift);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.ASK:
        if (oidSedanaShift != 0) {
          try {
            obj = PstSedanaShift.fetchExc(oidSedanaShift);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.DELETE:
        if (oidSedanaShift != 0) {
          try {
            this.cloneObj = pst.fetchExc(oidSedanaShift);
            long oid = PstSedanaShift.deleteExc(oidSedanaShift);
            if (oid != 0) {
              msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
              excCode = RSLT_OK;
              logSysHistory.setLogUserAction("DELETE");
              history.combine(this.cloneObj.historyNew());
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
      logSysHistory.setLogDocumentId(oidSedanaShift);
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }
    return excCode;
  }
}
