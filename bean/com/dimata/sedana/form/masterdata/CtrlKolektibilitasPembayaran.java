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
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.qdep.db.*;
import com.dimata.qdep.form.*;
import com.dimata.qdep.system.*;
import com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran;
import com.dimata.sedana.session.SessHistory;
import com.dimata.sedana.session.json.JSONObject;
import com.dimata.util.*;
import com.dimata.util.lang.*;
import javax.servlet.http.*;

/*
 Description : Controll KolektibilitasPembayaran
 Date : Tue Jul 04 2017
 Author : Regen
 */
public class CtrlKolektibilitasPembayaran extends Control implements I_Language {

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
  private KolektibilitasPembayaran ent;
  private PstKolektibilitasPembayaran pst;
  private FrmKolektibilitasPembayaran frm;
  int language = LANGUAGE_DEFAULT;

  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  KolektibilitasPembayaran tmpEnt = new KolektibilitasPembayaran();

  public CtrlKolektibilitasPembayaran(HttpServletRequest request) {
    msgString = "";
    ent = new KolektibilitasPembayaran();
    try {
      pst = new PstKolektibilitasPembayaran(0);
    } catch (Exception e) {;
    }
    frm = new FrmKolektibilitasPembayaran(request, ent);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_KOLEKTIBILITAS_PEMBAYARAN]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
  }

  private String getSystemMessage(int msgCode) {
    switch (msgCode) {
      case I_DBExceptionInfo.MULTIPLE_ID:
        this.frm.addError(frm.FRM_FIELD_KOLEKTIBILITASID, resultText[language][RSLT_EST_CODE_EXIST]);
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

  public KolektibilitasPembayaran getKolektibilitasPembayaran() {
    return ent;
  }

  public FrmKolektibilitasPembayaran getForm() {
    return frm;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int action(int cmd, long oidKolektibilitasPembayaran) {
    msgString = "";
    int excCode = I_DBExceptionInfo.NO_EXCEPTION;
    int rsCode = RSLT_OK;
    switch (cmd) {
      case Command.ADD:
        break;

      case Command.SAVE:
        if (oidKolektibilitasPembayaran != 0) {
          try {
            ent = PstKolektibilitasPembayaran.fetchExc(oidKolektibilitasPembayaran);
            tmpEnt = ent == null ? tmpEnt : ent.clone();
          } catch (Exception exc) {
          }
        }

        frm.requestEntityObject(ent);

        if (frm.errorSize() > 0) {
          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
          return RSLT_FORM_INCOMPLETE;
        }

        if (ent.getOID() == 0) {
          try {
            oidKolektibilitasPembayaran = pst.insertExc(this.ent);
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
            oidKolektibilitasPembayaran = pst.updateExc(this.ent);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(tmpEnt.historyCompare(this.ent));
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }

        }
        break;

      case Command.EDIT:
        if (oidKolektibilitasPembayaran != 0) {
          try {
            ent = PstKolektibilitasPembayaran.fetchExc(oidKolektibilitasPembayaran);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.ASK:
        if (oidKolektibilitasPembayaran != 0) {
          try {
            ent = PstKolektibilitasPembayaran.fetchExc(oidKolektibilitasPembayaran);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.DELETE:
        if (oidKolektibilitasPembayaran != 0) {
          try {
            this.tmpEnt = pst.fetchExc(oidKolektibilitasPembayaran);
            long oid = PstKolektibilitasPembayaran.deleteExc(oidKolektibilitasPembayaran);
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
      logSysHistory.setLogDocumentId(oidKolektibilitasPembayaran);
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }
    return rsCode;
  }
}
