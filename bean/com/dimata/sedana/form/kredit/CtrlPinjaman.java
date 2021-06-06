/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.form.kredit;

import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.qdep.form.Control;
import com.dimata.qdep.form.FRMMessage;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.session.SessAutoCode;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import static com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dw1p4
 */
public class CtrlPinjaman extends Control implements I_Language {

    public static final int RSLT_OK = 0;
    public static final int RSLT_SAME = 1;
    public static final int RSLT_INCOMPLETE = 2;
    public static final int RSLT_EXIST = 3;
    public static final int RSLT_UNKNOWN = 4;

    public static String resultText[][] = {
        {"OK ...", "Data sama ...", "Form belum lengkap ...", "Account link sudah ada ...", "Kesalahan unknown ..."},
        {"OK ...", "Same Data...", "Form incomplete ...", "Link account already exist ...", "Unknown Error ..."}
    };

    private int start;
    private String msgString;
    private Pinjaman pinjaman;
    private PstPinjaman pstPinjaman;
    private FrmPinjaman frmPinjaman;
    private int language = LANGUAGE_DEFAULT;

    public String historyInsert = "";
    public String historyUpdate = "";
    public String historyDelete = "";

    public CtrlPinjaman(HttpServletRequest request) {
        msgString = "";
        pinjaman = new Pinjaman();
        try {
            pstPinjaman = new PstPinjaman(0);
        } catch (Exception e) {
        }
        frmPinjaman = new FrmPinjaman(request, pinjaman);
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Pinjaman getPinjaman() {
        return pinjaman;
    }

    public FrmPinjaman getForm() {
        return frmPinjaman;
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
                frmPinjaman.requestEntityObject(pinjaman);
                pinjaman.setOID(Oid);

                if (frmPinjaman.errorSize() > 0) {
                    msgString = resultText[language][RSLT_INCOMPLETE];
                    return RSLT_INCOMPLETE;
                }
                
                if (pinjaman.getOID() == 0) {
                    if (pinjaman.getNoKredit().length() == 0) {
                        BillMain billMain = new BillMain();
                        try {
                        billMain = PstBillMain.fetchExc(pinjaman.getBillMainId());
                      } catch (Exception e) { 
                      }
                        SessAutoCode s = new SessAutoCode();
                        s.setDbFieldToCheck(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]);
                        s.setDb(PstPinjaman.TBL_PINJAMAN);
                        s.setSysProp("CODE_PK");
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(pinjaman.getTglPengajuan());
                        s.setWhereClause("p."+PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN]+" LIKE '%"+cal.get(Calendar.YEAR)+"%' AND cbm."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]+"="+billMain.getLocationId());
                        String nomorKredit = s.generatePk(billMain.getLocationId(), pinjaman.getCategoryPinjaman(),0); 
                        String whereNoPK = PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]+"='"+nomorKredit+"'";
                        Vector listPK = PstPinjaman.list(0, 0, whereNoPK, "");
                        boolean isDouble = false;
                        if (listPK.size()>0){
                            isDouble = true;
                        }
                        if (isDouble){
                            int add = 1;
                            while (isDouble) {                                
                                nomorKredit = s.generatePk(billMain.getLocationId(), pinjaman.getCategoryPinjaman(),add); 
                                whereNoPK = PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]+"='"+nomorKredit+"'";
                                listPK = PstPinjaman.list(0, 0, whereNoPK, "");
                                if (listPK.size()==0){
                                    isDouble = false;
                                } else {
                                    add++;
                                }
                            }
                        }
//                        s.setSysProp("CODE_CREDIT");
//                        String nomorKredit = s.generate(billMain.getLocationId()); 
                        pinjaman.setNoKredit(nomorKredit);
                        pinjaman.setStatusDenda(1);
                        String whereNoDouble = PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]+"='"+billMain.getOID()+"'";
                        Vector listDouble = PstPinjaman.list(0, 0, whereNoDouble, "");
                        if (listDouble.size()>0){
                            msgString = "Kredit dengan bill ini sudah ada!";
                            return RSLT_UNKNOWN;
                        }
                    } else {
                        Vector<Pinjaman> listKredit = PstPinjaman.list(0, 0, PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " = '" + pinjaman.getNoKredit() + "'", null);
                        if (!listKredit.isEmpty()) {
                            msgString = "Nomor kredit sudah ada";
                            return RSLT_UNKNOWN;
                        }
                    }
                    try {
                        long oid = pstPinjaman.insertExc(this.pinjaman);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_SAVED);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                } else {
                    try {
                        if (pinjaman.getNoKredit().length() == 0) {
                              BillMain billMain = new BillMain();
                              try {
                              billMain = PstBillMain.fetchExc(pinjaman.getBillMainId());
                            } catch (Exception e) {
                            }
                            SessAutoCode s = new SessAutoCode();
                            s.setDbFieldToCheck(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]);
                            s.setDb(PstPinjaman.TBL_PINJAMAN);
                            s.setSysProp("CODE_PK");
                            String nomorKredit = s.generatePk(billMain.getLocationId(), pinjaman.getCategoryPinjaman(),0); 
//                            s.setSysProp("CODE_CREDIT");
//                            String nomorKredit = s.generate(billMain.getLocationId());
                            pinjaman.setNoKredit(nomorKredit);
                        }
                        String where = PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " = '" + pinjaman.getNoKredit() + "'"
                                + " AND " + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " != '" + pinjaman.getOID()+ "'";
                        Vector<Pinjaman> listKredit = PstPinjaman.list(0, 0, where, null);
                        if (!listKredit.isEmpty()) {
                            msgString = "Nomor kredit sudah ada";
                            return RSLT_UNKNOWN;
                        }
                        long oid = pstPinjaman.updateExc(this.pinjaman);
                        msgString = FRMMessage.getMessage(FRMMessage.MSG_UPDATED);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.EDIT:
                if (Oid != 0) {
                    try {
                        pinjaman = (Pinjaman) pstPinjaman.fetchExc(Oid);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.ASK:
                if (Oid != 0) {
                    try {
                        pinjaman = (Pinjaman) pstPinjaman.fetchExc(Oid);
                    } catch (Exception exc) {
                        msgString = resultText[language][RSLT_UNKNOWN];
                        return RSLT_UNKNOWN;
                    }
                }
                break;

            case Command.DELETE:
                if (Oid != 0) {
                    PstPinjaman PstPinjaman = new PstPinjaman();
                    try {
                        long oid = PstPinjaman.deleteExc(Oid);
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
