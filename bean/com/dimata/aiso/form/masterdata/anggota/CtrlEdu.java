/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.aiso.form.masterdata.anggota;

import com.dimata.aiso.entity.masterdata.anggota.Education;
import com.dimata.aiso.entity.masterdata.anggota.PstEducation;
import static com.dimata.aiso.form.masterdata.mastertabungan.CtrlAfiliasi.RSLT_OK;
import com.dimata.common.entity.logger.LogSysHistory;
import com.dimata.common.entity.logger.PstLogSysHistory;
import com.dimata.qdep.db.DBException;
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
 * @author HaddyPuutraa
 */
public class CtrlEdu extends Control implements I_Language {

  public static int RSLT_OK = 0;
  public static int RSLT_UNKNOWN_ERROR = 1;
  public static int RSLT_EST_CODE_EXIST = 2;
  public static int RSLT_FORM_INCOMPLETE = 3;
  public static int RSLT_RECORD_NOT_FOUND = 4;

  public static String[][] resultText = {
    {"Proses Berhasil", "Tidak Dapat Diproses", "Sekolah Tersebut Sudah Ada", "Data Tidak Lengkap", "Data tidak ditemukan karena telah diubah oleh user lain"},
    {"Success", "Can not process", "Education Name exist", "Data Incomplete", "Data not found cause another user changed it"}
  };

  private int start;
  private String msgString;
  private Education education;
  private PstEducation pst;
  private FrmEducation frmEducation;

  private JSONObject history = new JSONObject();
  LogSysHistory logSysHistory = new LogSysHistory();
  Education cloneObj = new Education();

  int language = LANGUAGE_DEFAULT;

  public int getLanguge() {
    return language;
  }

  public void setLanguage(int language) {
    this.language = language;
  }

  public CtrlEdu(HttpServletRequest request) {
    msgString = "";
    education = new Education();
    try {
      pst = new PstEducation(0);
    } catch (Exception e) {

    }
    frmEducation = new FrmEducation(request, education);
    logSysHistory.setLogApplication((String) request.getAttribute("app"));
    logSysHistory.setLogDocumentType(SessHistory.document[SessHistory.DOC_MASTER_PENDIDIKAN]);
    logSysHistory.setLogOpenUrl("#");
    logSysHistory.setLogUpdateDate(new java.util.Date());
    logSysHistory.setLogLoginName((String) request.getAttribute("userFullName"));
    logSysHistory.setLogUserId((Long) request.getAttribute("userOID"));
  }

  private String getSystemMessage(int msgCode) {
    switch (msgCode) {
      case I_DBExceptionInfo.MULTIPLE_ID:
        this.frmEducation.addError(frmEducation.FRM_EDUCATION, resultText[language][RSLT_EST_CODE_EXIST]);
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

  public Education getEducation() {
    return education;
  }

  public FrmEducation getForm() {
    return frmEducation;
  }

  public String getMessage() {
    return msgString;
  }

  public int getStart() {
    return start;
  }

  public int actionList(int listCmd, int start, int vectSize, int recordToGet) {
    msgString = "";

    switch (listCmd) {
      case Command.FIRST:
        this.start = 0;
        break;

      case Command.PREV:
        this.start = start - recordToGet;
        if (start < 0) {
          this.start = 0;
        }
        break;

      case Command.NEXT:
        this.start = start + recordToGet;
        if (start >= vectSize) {
          this.start = start - recordToGet;
        }
        break;

      case Command.LAST:
        int mdl = vectSize % recordToGet;
        if (mdl > 0) {
          this.start = vectSize - mdl;
        } else {
          this.start = vectSize - recordToGet;
        }

        break;

      default:
        this.start = start;
        if (vectSize < 1) {
          this.start = 0;
        }

        if (start > vectSize) {
          // set to last
          mdl = vectSize % recordToGet;
          if (mdl > 0) {
            this.start = vectSize - mdl;
          } else {
            this.start = vectSize - recordToGet;
          }
        }
        break;
    } //end switch
    return this.start;
  }

  public int Action(int cmd, long Oid) throws DBException {
    int errCode = -1;
    int excCode = 0;
    int rsCode = 0;

    switch (cmd) {
      case Command.ADD:
        break;

      case Command.SAVE:
        if (Oid != 0) {
          try {
            education = pst.fetchExc(Oid);
            cloneObj = education==null?cloneObj:education.clone();
          } catch (Exception exc) {

          }
        }

        frmEducation.requestEntityObject(education);
        if (frmEducation.errorSize() > 0) {
          msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
          return RSLT_FORM_INCOMPLETE;
        }

        if (education.getOID() == 0) {
          try { 
            Oid = pst.insertExc(this.education);
            logSysHistory.setLogUserAction("INSERT");
            frmEducation.requestEntityObject(cloneObj);
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
            Oid = pst.updateExc(this.education);
            logSysHistory.setLogUserAction("UPDATE");
            history.combine(cloneObj.historyCompare(this.education));
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.EDIT:
        if (Oid != 0) {
          try {
            education = pst.fetchExc(Oid);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.ASK:
        if (Oid != 0) {
          try {
            education = pst.fetchExc(Oid);
          } catch (DBException dbexc) {
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
          } catch (Exception exc) {
            msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
          }
        }
        break;

      case Command.DELETE:
        if (Oid != 0) {
          try {
            this.cloneObj = pst.fetchExc(Oid);
            long oid = pst.deleteExc(Oid);
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

    }//end switch
    
    if (logSysHistory != null
            && rsCode == RSLT_OK
            && logSysHistory.getLogUserAction() != null
            && !logSysHistory.getLogUserAction().equals("")) {
      logSysHistory.setLogDocumentId(Oid);
      logSysHistory.setLogDetail(history.toString());
      logSysHistory.setLogDocumentNumber("-");
      logSysHistory.setLogDocumentStatus(5);
      PstLogSysHistory.insertExc(logSysHistory);
    }
    
    return excCode;
  }
}
