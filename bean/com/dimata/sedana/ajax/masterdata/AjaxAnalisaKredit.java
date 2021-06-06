/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.masterdata;

import com.dimata.aiso.entity.admin.AppObjInfo;
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.harisma.entity.masterdata.Department;
import com.dimata.harisma.entity.masterdata.PstDepartment;
import com.dimata.harisma.entity.masterdata.PstDivision;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.entity.admin.PstUserGroup;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditDetail;
import com.dimata.sedana.entity.analisakredit.AnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.MasterAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.MasterGroupAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.MasterScore;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditDetail;
import com.dimata.sedana.entity.analisakredit.PstAnalisaKreditMain;
import com.dimata.sedana.entity.analisakredit.PstMasterAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.PstMasterGroupAnalisaKredit;
import com.dimata.sedana.entity.analisakredit.PstMasterScore;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.form.analisakredit.CtrlAnalisaKreditDetail;
import com.dimata.sedana.form.analisakredit.CtrlAnalisaKreditMain;
import com.dimata.sedana.form.analisakredit.CtrlMasterAnalisaKredit;
import com.dimata.sedana.form.analisakredit.CtrlMasterGroupAnalisaKredit;
import com.dimata.sedana.form.analisakredit.CtrlMasterScore;
import com.dimata.sedana.form.analisakredit.FrmAnalisaKreditDetail;
import com.dimata.sedana.form.analisakredit.FrmAnalisaKreditMain;
import com.dimata.sedana.form.analisakredit.FrmMasterAnalisaKredit;
import com.dimata.sedana.form.analisakredit.FrmMasterGroupAnalisaKredit;
import com.dimata.sedana.form.analisakredit.FrmMasterScore;
import com.dimata.services.WebServices;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author arise
 */
public class AjaxAnalisaKredit extends HttpServlet {

    //DATATABLES
    private String searchTerm;
    private String colName;
    private int colOrder;
    private String dir;
    private int start;
    private int amount;

    //OBJECT
    private JSONObject jSONObject = new JSONObject();
    private JSONArray jSONArray = new JSONArray();
    private JSONArray jsonArrayJenisKredit = new JSONArray();
    private JSONArray jsonArrayDataKredit = new JSONArray();
    private JSONArray jsonArrayPrintValue = new JSONArray();

    //LONG
    private long oidGroup = 0;
    private long oidAnalisa = 0;
    private long oidAnalisaMain = 0;
    private long oidAnalisaDetail = 0;
    private long oidKadiv = 0;
    private long oidManager = 0;
    private long oidPinjaman = 0;
    private long oidScore = 0;
    private long oidLocation = 0;

    //STRING
    private String dataFor = "";
    private String approot = "";
    private String htmlReturn = "";
    private String message = "";
    private String history = "";
    private String statusDoc = "";
    private String posApiUrl = "";
    private String hrApiUrl = "";

    //BOOLEAN
    private boolean privAdd = false;
    private boolean privUpdate = false;
    private boolean privDelete = false;
    private boolean privView = false;
    private boolean sessLogin = false;
    private boolean privAccept = false;

    //INT
    private int iCommand = 0;
    private int iErrCode = 0;
    private int sessLanguage = 0;

    private long userId = 0;
    private String userName = "";

    //ADDITIONAL
    private String form_num = "";
    private String kredit_num = "";
    private String start_date = "";
    private String end_date = "";
    private List<String> form_status = new ArrayList<>();
    private Vector listUserGroup = new Vector();
    private SessUserSession userSession = new SessUserSession();

    private String textAnalisaDetailForm[][] = {
        {"Pilih Group Analisa", "Pilih Analisa Detail", "Nilai", "Bobot", "Catatan"},
        {"Select Analysis Group", "Select Analysis Detail", "Score", "Weight", "Note"}
    };

    private String textAnalisForm[][] = {
        {"Kode", "Group", "Deskripsi", "Pilih master group"},
        {"Code", "Group", "Description", "Select master group"}
    };

    private String textMasterForm[][] = {
        {"Group ID", "Deskripsi", "Bobot", "Minimal", "Maksimal"},
        {"Group ID", "Description", "Value", "Minimal", "Maximal"}
    };

    private String textScoreForm[][] = {
        {"Skor", "Deskripsi"},
        {"Score", "Description"}
    };

    private String textGlobal[][] = {
        {"Pilih"},
        {"Select"}
    };

    public static NumberFormat formatNumber = NumberFormat.getInstance(new Locale("id", "ID"));

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // OBJECT
        this.jsonArrayJenisKredit = new JSONArray();
        this.jsonArrayDataKredit = new JSONArray();
        this.jsonArrayPrintValue = new JSONArray();
        this.jSONArray = new JSONArray();
        this.jSONObject = new JSONObject();

        //LONG
        this.oidGroup = FRMQueryString.requestLong(request, "MASTER_OID");
        this.oidAnalisa = FRMQueryString.requestLong(request, "ANALISA_OID");
        this.oidAnalisaMain = FRMQueryString.requestLong(request, "ANALISA_MAIN_OID");
        this.oidAnalisaDetail = FRMQueryString.requestLong(request, "ANALISA_DETAIL_OID");
        this.oidKadiv = FRMQueryString.requestLong(request, "KADIV_OID");
        this.oidManager = FRMQueryString.requestLong(request, "MANAGER_OID");
        this.oidPinjaman = FRMQueryString.requestLong(request, "PINJAMAN_OID");
        this.oidScore = FRMQueryString.requestLong(request, "SCORE_OID");
        this.oidLocation = FRMQueryString.requestLong(request, "FRM_FIELD_LOCATION_OID");

        //STRING
        this.dataFor = FRMQueryString.requestString(request, "FRM_FIELD_DATA_FOR");
        this.approot = FRMQueryString.requestString(request, "FRM_FIELD_APPROOT");
        this.htmlReturn = "";
        this.message = "";
        this.history = "";
        this.statusDoc = FRMQueryString.requestString(request, "SEND_STATUS_DOC");
        this.posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        this.hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");

        //BOOLEAN
        this.privAdd = FRMQueryString.requestBoolean(request, "privadd");
        this.privUpdate = FRMQueryString.requestBoolean(request, "privupdate");
        this.privDelete = FRMQueryString.requestBoolean(request, "privdelete");
        this.privView = FRMQueryString.requestBoolean(request, "privview");
        this.sessLogin = false;

        //INT
        this.iCommand = FRMQueryString.requestCommand(request);
        this.iErrCode = 0;
        this.sessLanguage = FRMQueryString.requestInt(request, "SESS_LANGUAGE");

        //OBJECT
        this.jSONObject = new JSONObject();

        this.userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
        this.userName = FRMQueryString.requestString(request, "SEND_USER_NAME");

        //ADDITIONAL
        this.form_num = FRMQueryString.requestString(request, "form_num");
        this.kredit_num = FRMQueryString.requestString(request, "kredit_num");
        this.start_date = FRMQueryString.requestString(request, "startDate");
        this.end_date = FRMQueryString.requestString(request, "endDate");
        String[] strList = request.getParameterValues("form_status");
        if (strList != null) {
            this.form_status = Arrays.asList(strList);
        }

        //CHECK USER LOGIN SESSION
        HttpSession session = request.getSession();
        Cookie[] cookies = request.getCookies();
        String sessionId = "";
        if(cookies !=null){
            for(Cookie cookie : cookies){
                    if(cookie.getName().equals("JSESSIONID")) sessionId = cookie.getValue();
                    //session.putValue(sessionId, userSess);
            }
        }
        userSession = (SessUserSession) session.getValue(sessionId);
        if (userSession != null) {
            if (userSession.isLoggedIn()) {
                this.sessLogin = true;
                int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
                privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
                String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
                String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
                        + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
                listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
            }
        }

        if (this.sessLogin == true) {
            switch (this.iCommand) {
                case Command.SAVE:
                    commandSave(request, response);
                    break;

                case Command.DELETE:
                    commandDelete(request, response);
                    break;

                case Command.LIST:
                    commandList(request, response);
                    break;

                default:
                    commandNone(request, response);
                    break;
            }
        } else {
            this.iErrCode = 1;
            this.message = "Sesi login Anda telah berakhir. Silakan login ulang untuk melanjutkan.";
        }

        try {

            this.jSONObject.put("FRM_FIELD_HTML", this.htmlReturn);
            this.jSONObject.put("RETURN_SESSION_LOGIN", this.sessLogin);
            this.jSONObject.put("RETURN_ERROR_CODE", "" + this.iErrCode);
            this.jSONObject.put("RETURN_MESSAGE", "" + this.message);

        } catch (JSONException jSONException) {
            jSONException.printStackTrace();
        }

        response.getWriter().print(this.jSONObject);

    }

    //COMMAND LIST==============================================================
    public void commandList(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("listMasterGroupAnalisa")) {
            String[] cols = {
                "",
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID],
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION],
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT],
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MIN],
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MAX],};
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listMasterAnalisaKredit")) {
            String[] cols = {
                "",
                PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_ANALISAID],
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION],
                PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION]
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listDetailPenilaian")) {
            String[] cols = {
                PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION],
                "",
                "",
                "",
                "",
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listKepalaDivisi")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listManagerOperasional")) {
            String[] cols = {
                "",
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM],
                "emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME],
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listForm5C")) {
            String[] cols = {
                "",
                PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER],
                PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listSelectPinjaman")) {
            String[] cols = {
                "",
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN],
                "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME],
                "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN],
                "",
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        } else if (this.dataFor.equals("listScoreMaster")) {
            String[] cols = {
                "",
                PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MIN],
                PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MAX],
                PstMasterScore.fieldNames[PstMasterScore.FLD_DESCRIPTION],
                ""
            };
            jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
        }
    }

    //COMMAND NONE==============================================================
    public void commandNone(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("showMasterGroupForm")) {
            showForm(request, response);
        } else if (this.dataFor.equals("showMasterAnalisaForm")) {
            showForm(request, response);
        } else if (this.dataFor.equals("showMasterAnalisaGroupOption")) {
            showMasterAnalisaGroupOption(request, response);
        } else if (this.dataFor.equals("showMasterAnalisaOption")) {
            showMasterAnalisaOption(request, response);
        } else if (this.dataFor.equals("showInputNilai")) {
            showInputNilai(request, response);
        } else if (this.dataFor.equals("showUpdateAnalisaDetailForm")) {
            showForm(request, response);
        } else if (this.dataFor.equals("fetchPinjaman")) {
            jSONObject = fecthingPinjaman(request, response);
        } else if (this.dataFor.equals("showMasterScoreForm")) {
            showMasterScoreForm(request, response);
        }
    }

    // COMMAND SAVE ============================================================================
    public void commandSave(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("saveMasterGroup")) {
            saveMasterGroup(request, response);
        } else if (this.dataFor.equals("saveMasterAnalisaKredit")) {
            saveMasterAnalisaKredit(request, response);
        } else if (this.dataFor.equals("saveForm5C")) {
            saveForm5C(request, response);
        } else if (this.dataFor.equals("saveDetailPenilaian")) {
            saveDetailPenilaian5C(request, response);
        } else if (this.dataFor.equals("saveMasterScore")) {
            saveMasterScore(request, response);
        }
    }
    // COMMAND DELETE ============================================================================

    public void commandDelete(HttpServletRequest request, HttpServletResponse response) {
        if (this.dataFor.equals("deleteAnalisaDetail")) {
            deleteAnalisaDetail(request, response);
        } else if (this.dataFor.equals("deleteMasterAnalisaGroup")) {
            deleteMasterGroupAnalisa(request, response);
        } else if (this.dataFor.equals("deleteMasterAnalisa")) {
            deleteMasterAnalisa(request, response);
        } else if (this.dataFor.equals("deleteMasterScore")) {
            deleteMasterScore(request, response);
        }
    }

    // COMMAND SAVE ============================================================================
    public void saveMasterGroup(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterGroupAnalisaKredit cmgak = new CtrlMasterGroupAnalisaKredit(request);
        this.iErrCode = cmgak.action(this.iCommand, this.oidGroup);
        long oidRes = cmgak.getOidRes();
        if (oidRes != 0) {
            this.message = "Simpan Berhasil.";
        } else {
            this.message = "Simpan Gagal.\n";
            this.message += cmgak.getMessage();
            this.message += "\nPastikan data dengan benar lalu coba lagi";
        }
    }

    public void saveMasterAnalisaKredit(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterAnalisaKredit cmak = new CtrlMasterAnalisaKredit(request);
        this.iErrCode = -1;
        cmak.action(this.iCommand, this.oidAnalisa);
        long oidRes = cmak.getOidRes();
        if (oidRes != 0) {
            this.message = "Simpan Berhasil.";
            this.iErrCode = 0;
        } else {
            this.message = "Simpan Gagal.\n";
            this.message += cmak.getMessage();
            this.message += "\nPastikan data dengan benar lalu coba lagi";
        }
    }

    public void saveForm5C(HttpServletRequest request, HttpServletResponse response) {
        CtrlAnalisaKreditMain cakm = new CtrlAnalisaKreditMain(request);
        cakm.action(this.iCommand, this.oidAnalisaMain);
        long oidRes = cakm.getOidRes();
        if (oidRes != 0) {
            this.message = "Simpan Berhasil.";
        } else {
            this.message = "Simpan Gagal.\nPastikan data dengan benar lalu coba lagi";
            oidRes = this.oidAnalisaMain;
        }
        this.htmlReturn = String.valueOf(oidRes);
    }

    public void saveDetailPenilaian5C(HttpServletRequest request, HttpServletResponse response) {
        CtrlAnalisaKreditDetail cakd = new CtrlAnalisaKreditDetail(request);
        cakd.action(this.iCommand, this.oidAnalisaDetail);
        long oidRes = cakd.getOidRes();
        if (oidRes != 0) {
            this.message = "Simpan Berhasil.";
        } else {
            this.message = "Simpan Gagal.\nPastikan data dengan benar lalu coba lagi";
        }
    }

    public void saveMasterScore(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterScore cms = new CtrlMasterScore(request);
        this.iErrCode = -1;
        cms.action(this.iCommand, this.oidScore);
        long oidRes = cms.getOidRes();
        long oidGroup = cms.getGroupOidRes();
        if (oidRes != 0) {
            this.message = "Simpan Berhasil.";
            this.htmlReturn = "&MASTER_OID=" + oidGroup + "&SCORE_OID=" + oidRes;
            this.iErrCode = 0;
        } else {
            this.message = "Simpan Gagal.\nPastikan data dengan benar lalu coba lagi";
        }
    }

    // COMMAND DELETE ============================================================================
    public void deleteAnalisaDetail(HttpServletRequest request, HttpServletResponse response) {
        CtrlAnalisaKreditDetail cakd = new CtrlAnalisaKreditDetail(request);
        cakd.action(this.iCommand, this.oidAnalisaDetail);
        long oidRes = cakd.getOidRes();
        if (oidRes != 0) {
            this.message = "Hapus Berhasil.";
        } else {
            this.message = "Hapus Gagal.\nPastikan data dengan benar lalu coba lagi";
        }
    }

    public void deleteMasterGroupAnalisa(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterGroupAnalisaKredit cmgak = new CtrlMasterGroupAnalisaKredit(request);
        boolean status = PstMasterGroupAnalisaKredit.checkMasterUsed(this.oidGroup);
        long oidRes = 0;
        this.iErrCode = 0;
        if (!status) {
            cmgak.action(this.iCommand, this.oidGroup);
            oidRes = cmgak.getOidRes();
        }
        if (oidRes != 0) {
            this.message = "Hapus Berhasil.";
        } else {
            this.iErrCode = -1;
            this.message = "Hapus Gagal.\nData master sudah digunakan dan tidak dapat dihapus!";
        }
    }

    public void deleteMasterAnalisa(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterAnalisaKredit cmak = new CtrlMasterAnalisaKredit(request);
        this.iErrCode = -1;
        boolean status = PstMasterAnalisaKredit.checkMasterUsed(this.oidAnalisa);
        long oidRes = 0;
        if (!status) {
            cmak.action(this.iCommand, this.oidAnalisa);
            oidRes = cmak.getOidRes();
        }
        if (oidRes != 0) {
            this.message = "Hapus Berhasil.";
            this.iErrCode = 0;
        } else {
            this.message = "Hapus Gagal.\nData master sudah digunakan dan tidak dapat dihapus!";
        }
    }

    public void deleteMasterScore(HttpServletRequest request, HttpServletResponse response) {
        CtrlMasterScore cms = new CtrlMasterScore(request);
        cms.action(this.iCommand, this.oidScore);
        long oidRes = cms.getOidRes();
        if (oidRes != 0) {
            this.message = "Hapus Berhasil.";
            this.htmlReturn = "&MASTER_OID=" + this.oidGroup + "&SCORE_OID=" + oidRes;
        } else {
            this.message = "Simpan Gagal.\nPastikan data dengan benar lalu coba lagi";
        }
    }
    // COMMAND NONE ============================================================================

    public JSONObject fecthingPinjaman(HttpServletRequest request, HttpServletResponse response) {
        JSONObject json = new JSONObject();

        Pinjaman p = new Pinjaman();
//		Anggota a = new Anggota();
        Employee analis = new Employee();

        try {
            p = PstPinjaman.fetchExc(this.oidPinjaman);

//			a = PstAnggota.fetchExc(p.getAccountOfficerId());
            analis = PstEmployee.fetchFromApi(p.getAccountOfficerId());


            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + "=" + p.getOID()
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                    + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ")";
            Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.list(0, 2, whereClause, "");
            double jumlahAngsuran = 0;
            for(JadwalAngsuran ja : listAngsuran){
                jumlahAngsuran += ja.getJumlahANgsuran();
            }

            json.put("ANALIS_OID", analis.getOID());
            json.put("ANALIS_NAME", analis.getFullName());
            json.put("JUMLAH_ANGSURAN", jumlahAngsuran);

        } catch (Exception e) {
            this.message = "Something when wrong";
        }

        return json;
    }

    public void showMasterScoreForm(HttpServletRequest request, HttpServletResponse response) {
        String htmlOutput = "";

        MasterScore ms = new MasterScore();
        if (this.oidScore != 0) {
            try {
                ms = PstMasterScore.fetchExc(this.oidScore);
            } catch (Exception e) {
            }
        }

        htmlOutput += "<input type=\"hidden\" value=\"" + this.oidGroup + "\""
                + "name=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_GROUP_ID] + "\">"
                + "<input type=\"hidden\" value=\"" + ms.getOID() + "\""
                + "name=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_MASTER_SCORE_OID] + "\">"
                + "<div class=\"form-group\">"
                + "<label>" + textScoreForm[this.sessLanguage][0] + "</label>"
                + "<span data-toggle=\"tooltip\" data-placement=\"top\" data-html=\"true\" title=\""
                + "Kiri = Score Minimal<br>"
                + "Kanan = Score Maksimal\">"
                + "&nbsp;<i class=\"fa fa-question-circle\"></i>"
                + "</span>"
                + "<div class=\"input-group\">"
                + "<input type=\"number\" class=\"form-control\" value=\"" + ms.getScoreMin() + "\""
                + "id=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_SCORE_MIN] + "\""
                + "name=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_SCORE_MIN] + "\">"
                + "<span class=\"input-group-addon\"><i class=\"fa fa-minus\"></i></span>"
                + "<input type=\"number\" class=\"form-control\" value=\"" + ms.getScoreMax() + "\""
                + "id=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_SCORE_MAX] + "\""
                + "name=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_SCORE_MAX] + "\">"
                + "</div>"
                + "</div>"
                + "<div class=\"form-group\">"
                + "<label>" + textScoreForm[this.sessLanguage][1] + "</label>"
                + "<textarea class=\"form-control\" id=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_DESCRIPTION] + "\" "
                + "name=\"" + FrmMasterScore.fieldNames[FrmMasterScore.FRM_FIELD_DESCRIPTION] + "\" rows=\"3\">" + ms.getDescription() + "</textarea>"
                + "</div>";
        this.htmlReturn = htmlOutput;
    }

    public void showMasterAnalisaGroupOption(HttpServletRequest request, HttpServletResponse response) {
        Vector listMaster = PstMasterGroupAnalisaKredit.listAll();
        String listMasterOption = "";
        for (int i = 0; i < listMaster.size(); i++) {
            MasterGroupAnalisaKredit mgak = (MasterGroupAnalisaKredit) listMaster.get(i);
            listMasterOption += "<option value=\"" + mgak.getOID() + "\">" + mgak.getGroupDesc() + "</option>";
        }
        String htmlOption = "<input type=\"hidden\" value=\"" + this.oidAnalisaMain + "\""
                + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_ANALISAKREDITMAINID] + "\""
                + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_ANALISAKREDITMAINID] + "\">"
                + "<div class=\"col-sm-12 form-group\">"
                + "<label>" + textAnalisaDetailForm[this.sessLanguage][0] + "</label>"
                + "<select class=\"form-control select2\" style=\"width: 100%;\""
                + "name=\"master_group\""
                + "id=\"master_group_\">"
                + "<option disabled selected>" + textAnalisaDetailForm[this.sessLanguage][0] + "</option>"
                + listMasterOption
                + "</select>"
                + "</div>";

        this.htmlReturn = htmlOption;
    }

    public void showMasterAnalisaOption(HttpServletRequest request, HttpServletResponse response) {
        long masterOid = FRMQueryString.requestLong(request, "master_group");
        String whereClause = PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] + "=" + masterOid;
        whereClause += " AND " + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID]
                + " NOT IN(SELECT " + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_MASTERANALISAKREDITID]
                + " FROM " + PstAnalisaKreditDetail.TBL_ANALISAKREDITDETAIL
                + " WHERE " + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITMAINID] + "=" + this.oidAnalisaMain + ")";
        Vector listAnalisa = PstMasterAnalisaKredit.list(0, 0, whereClause, "");
        String analisaOption = "";
        for (int i = 0; i < listAnalisa.size(); i++) {
            MasterAnalisaKredit mak = (MasterAnalisaKredit) listAnalisa.get(i);
            analisaOption += "<option value=\"" + mak.getOID() + "\"> " + mak.getDescription() + " </option>";
        }
        String htmlOption = "<div class=\"col-sm-12 form-group\">"
                + "<label>" + textAnalisaDetailForm[this.sessLanguage][1] + "</label>"
                + "<select class=\"form-control select2\" style=\"width: 100%;\""
                + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] + "\""
                + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] + "\">"
                + "<option disabled selected>" + textAnalisaDetailForm[this.sessLanguage][1] + "</option>"
                + analisaOption
                + "</select>"
                + "</div>";
        this.htmlReturn = htmlOption;
    }

    public void showInputNilai(HttpServletRequest request, HttpServletResponse response) {
        long analisaOid = FRMQueryString.requestLong(request, FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID]);
        MasterAnalisaKredit mak = new MasterAnalisaKredit();
        MasterGroupAnalisaKredit mgak = new MasterGroupAnalisaKredit();
        try {
            mak = PstMasterAnalisaKredit.fetchExc(analisaOid);
            mgak = PstMasterGroupAnalisaKredit.fetchExc(mak.getGroupId());
        } catch (Exception e) {
        }
        String rangeNilaiOption = "";
        for (int i = 0; i < mgak.getGroupMax() + 1; i++) {
            rangeNilaiOption += "<option value=\"" + i + "\">" + i + "</option>";
        }
        String htmlOption = "<div class=\"col-sm-6\">"
                + "<div class=\"form-group\">"
                + "<label>" + textAnalisaDetailForm[this.sessLanguage][2]
                + "<span data-toggle=\"tooltip\" data-placement=\"top\" data-html=\"true\" title=\""
                + "0 = Sangat Buruk<br>"
                + "1 = Buruk<br>"
                + "2 = Sedang<br>"
                + "3 = Cukup Baik<br>"
                + "4 = Baik<br>"
                + "5 = Sangat Baik\">"
                + "&nbsp;<i class=\"fa fa-question-circle\"></i>"
                + "</span>"
                + "</label>"
                + "<select class=\"form-control select2\" style=\"width: 100%;\""
                + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NILAI] + "\""
                + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NILAI] + "\">"
                + rangeNilaiOption
                + "</select>"
                + "</div>"
                + "</div>"
                + "<div class=\"col-sm-6\">"
                + "<div class=\"form-group\">"
                + "<label>" + textAnalisaDetailForm[this.sessLanguage][3] + "</label>"
                + "<div class=\"input-group\">"
                + "<input type=\"text\" class=\"form-control\" value=\"" + mgak.getGroupBobot() + "\" readonly>"
                + "<span class=\"input-group-addon\">%</span>"
                + "</div>"
                + "</div>"
                + "</div>"
                + "<div class=\"col-sm-12 form-group\">"
                + "<label>" + textAnalisaDetailForm[this.sessLanguage][4] + "</label>"
                + "<textarea class=\"form-control\" rows=\"3\""
                + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NOTES] + "\""
                + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NOTES] + "\">"
                + "</textarea>"
                + "</div>";
        this.htmlReturn = htmlOption;
    }

    public void showForm(HttpServletRequest request, HttpServletResponse response) {
        String htmlForm = "";
        if (this.dataFor.equals("showMasterGroupForm")) {
            MasterGroupAnalisaKredit mgak = new MasterGroupAnalisaKredit();
            if (this.oidGroup != 0) {
                try {
                    mgak = PstMasterGroupAnalisaKredit.fetchExc(this.oidGroup);
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                }
            }
            htmlForm = "<div class='row'>"
                    + "<input type='hidden' value='" + mgak.getOID() + "' "
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_MASTER_GROUP_ID] + "'>"
                    + "<div class='col-md-6'>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPID] + "'>"
                    + textMasterForm[this.sessLanguage][0]
                    + "</label>"
                    + "<input type='text' class='form-control' value='" + mgak.getGroupId() + "' "
                    + "id='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPID] + "'"
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPID] + "'>"
                    + "</div>											"
                    + "</div>"
                    + "<div class='col-md-6'>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPDESC] + "'>"
                    + textMasterForm[this.sessLanguage][1]
                    + "</label>"
                    + "<input type='text' class='form-control' value='" + mgak.getGroupDesc() + "' "
                    + "id='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPDESC] + "'"
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPDESC] + "'>"
                    + "</div>"
                    + "</div>"
                    + "</div>"
                    + "<div class='row'>"
                    + "<div class='col-md-4'>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPBOBOT] + "'>"
                    + textMasterForm[this.sessLanguage][2]
                    + "</label>"
                    + "<input type='number' class='form-control' value='" + mgak.getGroupBobot() + "' "
                    + "id='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPBOBOT] + "'"
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPBOBOT] + "'>"
                    + "</div>"
                    + "</div>"
                    + "<div class='col-md-4'>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMIN] + "'>"
                    + textMasterForm[this.sessLanguage][3]
                    + "</label>"
                    + "<input type='number' class='form-control' value='" + mgak.getGroupMin() + "' "
                    + "id='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMIN] + "'"
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMIN] + "'>"
                    + "</div>"
                    + "</div>"
                    + "<div class='col-md-4'>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMAX] + "'>"
                    + textMasterForm[this.sessLanguage][4]
                    + "</label>"
                    + "<input type='number' class='form-control' value='" + mgak.getGroupMax() + "' "
                    + "id='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMAX] + "'"
                    + "name='" + FrmMasterGroupAnalisaKredit.fieldNames[FrmMasterGroupAnalisaKredit.FRM_FIELD_GROUPMAX] + "'>"
                    + "</div>"
                    + "</div>"
                    + "</div>";

        } else if (this.dataFor.equals("showMasterAnalisaForm")) {
            MasterAnalisaKredit mak = new MasterAnalisaKredit();
            Vector listGroup = new Vector(1, 1);
            try {
                if (this.oidAnalisa != 0) {
                    mak = PstMasterAnalisaKredit.fetchExc(this.oidAnalisa);
                }
                listGroup = PstMasterGroupAnalisaKredit.listAll();
            } catch (Exception e) {
                printErrorMessage(e.getMessage());
            }
            htmlForm = "<div class='form-group'>"
                    + "<label for='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_ANALISAID] + "'>"
                    + textAnalisForm[this.sessLanguage][0]
                    + "</label>"
                    + "<input type='text' class='form-control' "
                    + "value='" + mak.getAnalisaId() + "' "
                    + "id='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_ANALISAID] + "' "
                    + "name='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_ANALISAID] + "'>"
                    + "</div>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_GROUPID] + "'>"
                    + textAnalisForm[this.sessLanguage][1]
                    + "</label>"
                    + "<select class='form-control' "
                    + "id='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_GROUPID] + "' "
                    + "name='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_GROUPID] + "'>"
                    + "<option value='0' disabled=''> " + textAnalisForm[this.sessLanguage][3] + " </option>";

            for (int i = 0; i < listGroup.size(); i++) {
                String selected = "";
                MasterGroupAnalisaKredit mgak = (MasterGroupAnalisaKredit) listGroup.get(i);
                if (mak.getGroupId() == mgak.getOID()) {
                    selected = "selected=''";
                }
                htmlForm += "<option value='" + mgak.getOID() + "' " + selected + ">" + mgak.getGroupDesc() + "</option>";
            }
            htmlForm += "</select>"
                    + "</div>"
                    + "<div class='form-group'>"
                    + "<label for='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_DESCRIPTION] + "'>"
                    + textAnalisForm[this.sessLanguage][2]
                    + "</label>"
                    + "<textarea type='text' class='form-control' "
                    + "id='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_DESCRIPTION] + "' "
                    + "name='" + FrmMasterAnalisaKredit.fieldNames[FrmMasterAnalisaKredit.FRM_FIELD_DESCRIPTION] + "'>"
                    + mak.getDescription()
                    + "</textarea>"
                    + "</div>";

        } else if (this.dataFor.equals("showUpdateAnalisaDetailForm")) {
            AnalisaKreditDetail akd = new AnalisaKreditDetail();
            MasterAnalisaKredit mak = new MasterAnalisaKredit();
            MasterGroupAnalisaKredit mgak = new MasterGroupAnalisaKredit();
            try {
                akd = PstAnalisaKreditDetail.fetchExc(this.oidAnalisaDetail);
                mak = PstMasterAnalisaKredit.fetchExc(akd.getMasterAnalisaKreditId());
                mgak = PstMasterGroupAnalisaKredit.fetchExc(mak.getGroupId());
            } catch (Exception e) {
            }
            String rangeNilaiOption = "";
            for (int i = 0; i < mgak.getGroupMax() + 1; i++) {
                String selected = "";
                if (akd.getNilai() == i) {
                    selected = " selected='selected'";
                }
                rangeNilaiOption += "<option value=\"" + i + "\"" + selected + ">" + i + "</option>";
            }
            htmlForm = "<input type=\"hidden\" value=\"" + akd.getAnalisaKreditMainId() + "\""
                    + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_ANALISAKREDITMAINID] + "\" "
                    + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_ANALISAKREDITMAINID] + "\">"
                    + "<input type=\"hidden\" value=\"" + akd.getMasterAnalisaKreditId() + "\""
                    + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] + "\" "
                    + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_MASTERANALISAKREDITID] + "\">"
                    + "<div class=\"row\">"
                    + "<div class=\"col-sm-12\">"
                    + "<div class=\"form-group\">"
                    + "<label>" + textAnalisaDetailForm[this.sessLanguage][0] + "</label>"
                    + "<input type=\"text\" class=\"form-control\" value=\"" + mgak.getGroupDesc() + "\" readonly=\"\">"
                    + "</div>"
                    + "</div>"
                    + "<div class=\"col-sm-12\">"
                    + "<div class=\"form-group\">"
                    + "<label>" + textAnalisaDetailForm[this.sessLanguage][1] + "</label>"
                    + "<input type=\"text\" class=\"form-control\" value=\"" + mak.getDescription() + "\" readonly=\"\">"
                    + "</div>"
                    + "</div>"
                    + "<div class=\"col-sm-6\">"
                    + "<div class=\"form-group\">"
                    + "<label>" + textAnalisaDetailForm[this.sessLanguage][2] + "</label>"
                    + "<select class=\"form-control select2\" style=\"width: 100%;\""
                    + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NILAI] + "\""
                    + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NILAI] + "\">"
                    + rangeNilaiOption
                    + "</select>"
                    + "</div>"
                    + "</div>"
                    + "<div class=\"col-sm-6\">"
                    + "<div class=\"form-group\">"
                    + "<label>" + textAnalisaDetailForm[this.sessLanguage][3] + "</label>"
                    + "<input type=\"text\" class=\"form-control\" value=\"" + mgak.getGroupBobot() + "\" readonly=\"\">"
                    + "</div>"
                    + "</div>"
                    + "<div class=\"col-sm-12\">"
                    + "<div class=\"form-group\">"
                    + "<label>" + textAnalisaDetailForm[this.sessLanguage][4] + "</label>"
                    + "<textarea type=\"text\" class=\"form-control\""
                    + "id=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NOTES] + "\""
                    + "name=\"" + FrmAnalisaKreditDetail.fieldNames[FrmAnalisaKreditDetail.FRM_FIELD_NOTES] + "\">"
                    + akd.getNotes()
                    + "</textarea>"
                    + "</div>"
                    + "</div>"
                    + "</div>";
        }
        this.htmlReturn = htmlForm;
    }

    // COMMAND LIST ============================================================================
    public JSONObject listDataTables(HttpServletRequest request, HttpServletResponse response, String[] cols, String dataFor, JSONObject result) {
        this.searchTerm = FRMQueryString.requestString(request, "sSearch");
        int amount = 10;
        int start = 0;
        int col = 0;
        String dir = "asc";
        String sStart = request.getParameter("iDisplayStart");
        String sAmount = request.getParameter("iDisplayLength");
        String sCol = request.getParameter("iSortCol_0");
        String sdir = request.getParameter("sSortDir_0");

        if (sStart != null) {
            start = Integer.parseInt(sStart);
            if (start < 0) {
                start = 0;
            }
        }
        if (sAmount != null) {
            amount = Integer.parseInt(sAmount);
            if (amount < 10) {
                amount = 10;
            }
        }
        if (sCol != null) {
            col = Integer.parseInt(sCol);
            if (col < 0) {
                col = 0;
            }
        }
        if (sdir != null) {
            if (!sdir.equals("asc")) {
                dir = "desc";
                if (dataFor.equals("listTransaksiKredit") || dataFor.equals("listHistory")) {
                    dir = "asc";
                }
            }
        }

        String whereClause = "";
        if (dataFor.equals("listMasterGroupAnalisa")) {
            whereClause += "("
                    + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MIN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MAX] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listMasterAnalisaKredit")) {
            whereClause += "("
                    + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_ANALISAID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listDetailPenilaian")) {
            whereClause = "";
        } else if (this.dataFor.equals("listKepalaDivisi")) {
            whereClause = "("
                    + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listManagerOperasional")) {
            whereClause = "("
                    + "emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listForm5C")) {
            whereClause = "("
                    + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstAnggota.TBL_ANGGOTA + "." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (" + PstPinjaman.TBL_PINJAMAN + "."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR " + PstPinjaman.TBL_PINJAMAN + "."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            if(this.oidLocation != 0){
                whereClause += " AND " + PstBillMain.TBL_CASH_BILL_MAIN + "." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + this.oidLocation;
            }
            if (this.form_num != null && this.form_num.length() > 0) {
                whereClause += " AND " + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER] + "='" + this.form_num + "'";
            }
            if (this.kredit_num != null && this.kredit_num.length() > 0) {
                whereClause += " AND " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + "='" + this.kredit_num + "'";
            }
            if ((this.start_date != null && this.start_date.length() > 0) && (this.end_date != null && this.end_date.length() > 0)) {
                whereClause += " AND ("
                        + "(TO_DAYS(" + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISATGL] + ") "
                        + ">= TO_DAYS('" + Formater.formatDate(this.start_date, "yyyy-MM-DD") + "')) AND "
                        + "(TO_DAYS(" + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISATGL] + ") "
                        + "<= TO_DAYS('" + Formater.formatDate(this.end_date, "yyyy-MM-DD") + "'))"
                        + ")";
            }
            if (this.form_status.size() > 0) {
                whereClause += " AND (";
                for (int i = 0; i < this.form_status.size(); i++) {
                    if (i > 0) {
                        whereClause += " OR ";
                    }
                    whereClause += PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS] + " = " + this.form_status.get(i) + " ";
                }
                whereClause += ")";
            }
        } else if (this.dataFor.equals("listSelectPinjaman")) {
            whereClause = "("
                    + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
        } else if (this.dataFor.equals("listScoreMaster")) {
            whereClause = "("
                    + PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MIN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MAX] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterScore.fieldNames[PstMasterScore.FLD_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        }

        String colName = cols[col];
        int total = -1;

        //cek parameter daftar transaksi
        String addSql = "";

        if (dataFor.equals("listMasterGroupAnalisa")) {
            total = PstMasterGroupAnalisaKredit.getCount(whereClause);
        } else if (dataFor.equals("listMasterAnalisaKredit")) {
            total = PstMasterAnalisaKredit.getCountJoinMasterGroup(whereClause);
        } else if (dataFor.equals("listDetailPenilaian")) {
            whereClause += PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITMAINID] + "=" + this.oidAnalisaMain;
            total = PstAnalisaKreditDetail.getCount(whereClause);
        } else if (dataFor.equals("listKepalaDivisi")) {
            long oidPosKadiv = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KADIV_KREDIT_OID"));
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + oidPosKadiv
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            String param = "limitStart=" + WebServices.encodeUrl("" + 0) + "&recordToGet=" + WebServices.encodeUrl("" + 0) + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            total = jo.optInt("COUNT");
        } else if (dataFor.equals("listManagerOperasional")) {
            long oidPosManOpr = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_MANAGER_OPERASIONAL_OID"));
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + oidPosManOpr
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            String param = "limitStart=" + WebServices.encodeUrl("" + 0) + "&recordToGet=" + WebServices.encodeUrl("" + 0) + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            total = jo.optInt("COUNT");
        } else if (this.dataFor.equals("listForm5C")) {
            total = PstAnalisaKreditMain.getCountJoin(whereClause);
        } else if (dataFor.equals("listSelectPinjaman")) {
            whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_TO_BE_APPROVE
                    + " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " <> 0)"
//                    + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " <> 0)";
                    + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " NOT IN (SELECT AKM." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PINJAMANID]
                    + " FROM " + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + " AS AKM)";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            total = PstPinjaman.getCountJoinPinjamanAnggota(whereClause);
        } else if (dataFor.equals("listScoreMaster")) {
            whereClause += " AND " + PstMasterScore.fieldNames[PstMasterScore.FLD_GROUP_ID] + " = " + this.oidGroup;
            total = PstMasterScore.getCount(whereClause);
        }

        this.amount = amount;

        this.colName = colName;
        this.dir = dir;
        this.start = start;
        this.colOrder = col;

        try {
            result = getData(total, request, dataFor, addSql);
        } catch (Exception ex) {
            printErrorMessage(ex.getMessage());
        }

        return result;
    }

    public JSONObject getData(int total, HttpServletRequest request, String datafor, String addSql) {
        int totalAfterFilter = total;
        JSONObject result = new JSONObject();
        JSONArray array = new JSONArray();
        JSONArray jArr = new JSONArray();
        MasterAnalisaKredit mak = new MasterAnalisaKredit();
        MasterGroupAnalisaKredit mgak = new MasterGroupAnalisaKredit();
        Employee emp = new Employee();
        Department dept = new Department();

        String whereClause = "";
        String order = "";

        if (datafor.equals("listMasterGroupAnalisa")) {
            whereClause += "("
                    + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MIN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MAX] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listMasterAnalisaKredit")) {
            whereClause += "("
                    + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_ANALISAID] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listDetailPenilaian")) {
            whereClause = "";
        } else if (this.dataFor.equals("listKepalaDivisi")) {
            whereClause = "("
                    + " emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listManagerOperasional")) {
            whereClause = "("
                    + " emp." + PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM] + " LIKE '%" + searchTerm + "%'"
                    + " OR emp." + PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        } else if (this.dataFor.equals("listForm5C")) {
            whereClause = "("
                    + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstAnggota.TBL_ANGGOTA + "." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (" + PstPinjaman.TBL_PINJAMAN + "."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR " + PstPinjaman.TBL_PINJAMAN + "."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            if(this.oidLocation != 0){
                whereClause += " AND " + PstBillMain.TBL_CASH_BILL_MAIN + "." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID] + " = " + this.oidLocation;
            }
            if (this.form_num != null && this.form_num.length() > 0) {
                whereClause += " AND " + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISANUMBER] + " LIKE '%" + this.form_num + "%'";
            }
            if (this.kredit_num != null && this.kredit_num.length() > 0) {
                whereClause += " AND " + PstPinjaman.TBL_PINJAMAN + "." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + this.kredit_num + "%'";
            }
            if ((this.start_date != null && this.start_date.length() > 0) && (this.end_date != null && this.end_date.length() > 0)) {
                Date startDate = Formater.formatDate(this.start_date, "yyyy-MM-dd");
                Date endDate = Formater.formatDate(this.end_date, "yyyy-MM-dd");
                whereClause += " AND ("
                        + "(TO_DAYS(" + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISATGL] + ") "
                        + ">= TO_DAYS('" + Formater.formatDate(startDate, "yyyy-MM-dd") + "')) AND "
                        + "(TO_DAYS(" + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISATGL] + ") "
                        + "<= TO_DAYS('" + Formater.formatDate(endDate, "yyyy-MM-dd") + "'))"
                        + ")";
            }
            if (this.form_status.size() > 0) {
                whereClause += " AND (";
                for (int i = 0; i < this.form_status.size(); i++) {
                    if (i > 0) {
                        whereClause += " OR ";
                    }
                    whereClause += PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + "." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS] + " LIKE '%" + this.form_status.get(i) + "%' ";
                }
                whereClause += ")";
            }
        } else if (this.dataFor.equals("listSelectPinjaman")) {
            whereClause = "("
                    + " pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_PENGAJUAN] + " LIKE '%" + searchTerm + "%'"
                    + " OR cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME] + " LIKE '%" + searchTerm + "%'"
                    + " OR pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN] + " LIKE '%" + searchTerm + "%'"
                    + ")";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
        } else if (this.dataFor.equals("listScoreMaster")) {
            whereClause = "("
                    + PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MIN] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MAX] + " LIKE '%" + searchTerm + "%'"
                    + " OR " + PstMasterScore.fieldNames[PstMasterScore.FLD_DESCRIPTION] + " LIKE '%" + searchTerm + "%'"
                    + ")";
        }

        if (this.colOrder >= 0) {
            order += "" + colName + " " + dir + "";
        }

        Vector listData = new Vector(1, 1);
        if (datafor.equals("listMasterGroupAnalisa")) {
            listData = PstMasterGroupAnalisaKredit.list(start, amount, whereClause, order);
        } else if (datafor.equals("listMasterAnalisaKredit")) {
            listData = PstMasterAnalisaKredit.listJoinMasterGroup(start, amount, whereClause, order);
        } else if (datafor.equals("listDetailPenilaian")) {
//			whereClause += PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITMAINID] + "=" + this.oidAnalisaMain;
            listData = PstAnalisaKreditDetail.listNilaiForm(this.oidAnalisaMain);
        } else if (datafor.equals("listKepalaDivisi")) {
            long oidKadiv = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KADIV_KREDIT_OID"));
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + oidKadiv
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            String param = "limitStart=" + WebServices.encodeUrl("" + start) + "&recordToGet=" + WebServices.encodeUrl("" + amount) + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl(order);
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            try {
                jArr = jo.getJSONArray("DATA");
            } catch (Exception e) {
            }
        } else if (datafor.equals("listManagerOperasional")) {
            long oidPosManOpr = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_MANAGER_OPERASIONAL_OID"));
            whereClause += " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_POSITION_ID] + "=" + oidPosManOpr
                    + " AND emp." + PstEmployee.fieldNames[PstEmployee.FLD_RESIGNED] + " = " + PstEmployee.NO_RESIGN;
            String param = "limitStart=" + WebServices.encodeUrl("" + start) + "&recordToGet=" + WebServices.encodeUrl("" + amount) + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl(order);
            JSONObject jo = WebServices.getAPIWithParam("", hrApiUrl + "/employee/employee-list", param);
            try {
                jArr = jo.getJSONArray("DATA"); 
            } catch (Exception e) {
            }
//			listData = PstEmployee.listEmpJoinDept(start, amount, whereClause, order);
        } else if (datafor.equals("listForm5C")) {
            listData = PstAnalisaKreditMain.getListJoin(start, amount, whereClause, order);
        } else if (datafor.equals("listSelectPinjaman")) {
            whereClause += " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_TO_BE_APPROVE
                    + " AND (pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID] + " <> 0)"
//                    + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " <> 0)"
                    + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " NOT IN (SELECT AKM." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_PINJAMANID]
                    + " FROM " + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + " AS AKM)";
            if (!privAccept && listUserGroup.isEmpty()) {
                whereClause += " AND (pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = " + userSession.getAppUser().getEmployeeId()
                        +" OR pinjaman."+ PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID]+" = " + userSession.getAppUser().getEmployeeId()+")";
            }
            listData = PstPinjaman.listJoinPinjamanAnggota(start, amount, whereClause, order); 
        } else if (dataFor.equals("listScoreMaster")) {
            whereClause += " AND " + PstMasterScore.fieldNames[PstMasterScore.FLD_GROUP_ID] + " = " + this.oidGroup;
            listData = PstMasterScore.list(start, amount, whereClause, order);
        }

        double totalNilai = 0;
        for (int i = 0; i <= listData.size() - 1; i++) {
            JSONArray ja = new JSONArray();
            if (datafor.equals("listMasterGroupAnalisa")) {
                mgak = (MasterGroupAnalisaKredit) listData.get(i);
                ja.put("<div class='text-center'>" + (this.start + i + 1) + ".</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupId() + "</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupDesc() + "</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupBobot() + "</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupMin() + "</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupMax() + "</div>");
                String button = "<div class='text-center'>"
                        + "<button type='button' "
                        + "title='Insert Score<br>untuk " + mgak.getGroupDesc() + "'"
                        + "data-toggle='tooltip' data-placement='top' data-html='true'"
                        + "class='btn btn-primary open-score-modal-btn' data-description='" + mgak.getGroupDesc() + "'"
                        + "value='" + mgak.getOID() + "'>"
                        + "<i class='fa fa-calendar-check-o'></i>"
                        + "</button>"
                        + "<span>&nbsp;</span>"
                        + "<button type='button'"
                        + "title='Update Data<br>untuk " + mgak.getGroupDesc() + "'"
                        + "data-toggle='tooltip' data-placement='top' data-html='true'"
                        + "class='btn btn-warning "
                        + "open-master-modal' value='" + mgak.getOID() + "'>"
                        + "<i class='fa fa-pencil'></i>"
                        + "</button>"
                        + "<span>&nbsp;</span>"
                        + "<button type='button'"
                        + "title='Delete Data<br>untuk " + mgak.getGroupDesc() + "'"
                        + "data-toggle='tooltip' data-placement='top' data-html='true'"
                        + "class='btn btn-danger "
                        + "delete-master-btn' value='" + mgak.getOID() + "'>"
                        + "<i class='fa fa-trash'></i>"
                        + "</button>"
                        + "</div>";
                ja.put(button);
                array.put(ja);
            } else if (datafor.equals("listMasterAnalisaKredit")) {
                Vector temp = (Vector) listData.get(i);
                mak = (MasterAnalisaKredit) temp.get(0);
                mgak = (MasterGroupAnalisaKredit) temp.get(1);
                ja.put("<div class='text-center'>" + (this.start + i + 1) + ".</div>");
                ja.put("<div class='text-center'>" + mak.getAnalisaId() + "</div>");
                ja.put("<div class='text-center'>" + mgak.getGroupDesc() + "</div>");
                ja.put("<div class='text-center'>" + mak.getDescription() + "</div>");
                String button = "<div class='text-center'>"
                        + "<button type='button' title='Update' "
                        + "data-toggle='tooltip' data-placement='top' data-html='true'"
                        + "class='btn btn-warning "
                        + "open-master-modal' value='" + mak.getOID() + "'>"
                        + "<i class='fa fa-pencil'></i>"
                        + "</button>"
                        + "<span>&nbsp;</span>"
                        + "<button type='button' title='Delete' "
                        + "data-toggle='tooltip' data-placement='top' data-html='true'"
                        + "class='btn btn-danger "
                        + "delete-master-btn' value='" + mak.getOID() + "'>"
                        + "<i class='fa fa-trash'></i>"
                        + "</button>"
                        + "</div>";
                ja.put(button);
                array.put(ja);
            } else if (datafor.equals("listDetailPenilaian")) {
                Vector temp = (Vector) listData.get(i);
                String gDesc = String.valueOf(temp.get(0));
                String desc = String.valueOf(temp.get(1));
                int nilai = Integer.parseInt(String.valueOf(temp.get(2)));
                int bobot = Integer.parseInt(String.valueOf(temp.get(3)));
                double skor = Double.parseDouble(String.valueOf(temp.get(4)));
                String notes = String.valueOf(temp.get(5));
                long oid = Long.parseLong(String.valueOf(temp.get(6)));
                int status = Integer.parseInt(String.valueOf(temp.get(7)));
                ja.put("<div class='text-center'>" + gDesc + "</div>");
                ja.put("<div class='text-left'>" + desc + "</div>");
                ja.put("<div class='text-center'>" + nilai + "</div>");
                ja.put("<div class='text-center'>" + bobot + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatNumber(skor, "###.##") + "</div>");
                ja.put("<div class='text-left'>" + notes + "</div>");

                String button = "";
                if (status == PstAnalisaKreditMain.ANALISA_STATUS_CLOSED) {
                    button = "<div class='text-center'>"
                            + "<span>" + PstAnalisaKreditMain.analisaStatusName[status] + "</span>"
                            + "</div>";
                } else if (status == PstAnalisaKreditMain.ANALISA_STATUS_DRAFT) {
                    button = "<div class='text-center'>"
                            + "<button type='button' title='Update' "
                            + "class='btn btn-sm btn-warning add-analisa-btn' value='" + oid + "'>"
                            + "<i class='fa fa-pencil'></i>"
                            + "</button>"
                            + "<span>&nbsp;</span>"
                            + "<button type='button' title='Delete' "
                            + "class='btn btn-sm btn-danger delete-analisa-btn' value='" + oid + "'>"
                            + "<i class='fa fa-trash'></i>"
                            + "</button>"
                            + "</div>";
                }
                ja.put(button);
                array.put(ja);
                totalNilai += skor;
            } else if (datafor.equals("listForm5C")) {
                Vector temp = (Vector) listData.get(i);
                AnalisaKreditMain akm = (AnalisaKreditMain) temp.get(0);
                Pinjaman p = (Pinjaman) temp.get(1);
                Anggota a = (Anggota) temp.get(2);

                ja.put("<div class='text-center'>" + (start + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + akm.getAnalisaNumber() + "</div>");
//				ja.put("<div class='text-left'>" + p.getNoKredit() + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatDate(akm.getAnalisaTgl(), "dd-MM-yyyy") + "</div>");
                ja.put("<div class='text-left'>" + a.getName() + "</div>");
                ja.put("<div class='text-center'>" + akm.getAnalisaNote() + "</div>");
                ja.put("<div class='text-center'>" + PstAnalisaKreditMain.analisaStatusName[akm.getAnalisaStatus()] + "</div>");
                String button = "<div class='text-center'>"
                        + "<button type='button' title='Select' "
                        + "class='btn btn-sm btn-warning open-form-btn' "
                        + "data-oidpinjaman='" + p.getOID() + "' "
                        + "value='" + akm.getOID() + "'>"
                        + "<i class='fa fa-pencil'></i>"
                        + "</button>"
                        + "</div>";
                ja.put(button);
                array.put(ja);
            } else if (datafor.equals("listSelectPinjaman")) {
                Pinjaman temp = (Pinjaman) listData.get(i);
                Anggota a = new Anggota();
                try {
                    a = PstAnggota.fetchExc(temp.getAnggotaId());
                } catch (Exception e) {
                }
                ja.put("<div class='text-center'>" + (start + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + temp.getNoKredit() + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatDate(temp.getTglPengajuan(), "dd-MM-yyyy") + "</div>");
                ja.put("<div class='text-left'>" + a.getName() + "</div>");
                ja.put("<div class='text-center'>" + formatNumber.format(temp.getJumlahPinjaman()) + "</div>");
                ja.put("<div class='text-center'>" + Pinjaman.STATUS_DOC_TITLE[temp.getStatusPinjaman()] + "</div>");
                String button = "<div class='text-center'>"
                        + "<button type='button' title='Select' "
                        + "class='btn btn-sm btn-warning select-pinjaman-btn' "
                        + "data-nokredit='" + temp.getNoKredit() + "' value='" + temp.getOID() + "'>"
                        + "<i class='fa fa-check'></i>"
                        + "</button>"
                        + "</div>";
                ja.put(button);
                array.put(ja);
            } else if (datafor.equals("listScoreMaster")) {
                MasterScore ms = (MasterScore) listData.get(i);
                ja.put("<div class='text-center'>" + (start + i + 1) + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatNumber(ms.getScoreMin(), "###.##") + "</div>");
                ja.put("<div class='text-center'>" + Formater.formatNumber(ms.getScoreMax(), "###.##") + "</div>");
                ja.put("<div class='text-center'>" + ms.getDescription() + "</div>");
                String button = "<div class='text-center'>"
                        + "<button type='button' title='Update Data'"
                        + "class='btn btn-sm btn-warning score-master-btn'"
                        + "value='" + ms.getGroupId() + "' data-score-oid='" + ms.getOID() + "'>"
                        + "<i class='fa fa-pencil'></i>"
                        + "</button>"
                        + "<span>&nbsp;</span>"
                        + "<button type='button' title='Delete Data' "
                        + "class='btn btn-sm btn-danger delete-score-btn' "
                        + "value='" + ms.getOID() + "' data-group-oid='" + ms.getGroupId() + "'>"
                        + "<i class='fa fa-trash'></i>"
                        + "</button>"
                        + "</div>";
                ja.put(button);
                array.put(ja);
            }
        }
        if (jArr.length() > 0) {
            for (int i = 0; i < jArr.length(); i++) {
                try {
                    JSONArray temp = jArr.optJSONArray(i);
                    JSONObject tempObj = temp.getJSONObject(0);
                    JSONObject division = temp.getJSONObject(1);
                    JSONArray ja = new JSONArray();

                    if (datafor.equals("listManagerOperasional") || datafor.equals("listKepalaDivisi")) {
                        String btnClass = "";
                        if (datafor.equals("listManagerOperasional")) {
                            btnClass = "1";
                        } else if (datafor.equals("listKepalaDivisi")) {
                            btnClass = "0";
                        }
                        ja.put("<div class='text-center'>" + (this.start + i + 1) + "</div>");
                        ja.put("<div class='text-center'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_NUM], "") + "</div>");
                        ja.put("<div class='text-left'>" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "") + "</div>");
                        ja.put("<div class='text-center'>" + division.optString(PstDivision.fieldNames[PstDivision.FLD_DIVISION], "") + "</div>");
                        String button = "<div class='text-center'>"
                                + "<button type='button' title='Update' "
                                + "class='btn btn-sm btn-warning select-emp-btn'"
                                + "data-pos-tipe='" + btnClass + "'"
                                + "data-name='" + tempObj.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "") + "'"
                                + "value='" + tempObj.optLong(PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID], 0) + "'>"
                                + "<i class='fa fa-check'></i>"
                                + "</button>"
                                + "</div>";
                        ja.put(button);
                        array.put(ja);
                    }
                } catch (Exception e) {
                }
            }
        }

        totalAfterFilter = total;
        this.htmlReturn = Formater.formatNumber(totalNilai, "###.##");
        try {
            result.put("iTotalRecords", total);
            result.put("iTotalDisplayRecords", totalAfterFilter);
            result.put("aaData", array);
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        }
        return result;
    }

    public void printErrorMessage(String errorMessage) {
        System.out.println("");
        System.out.println("========================================>>> WARNING <<<========================================");
        System.out.println("");
        System.out.println("MESSAGE : " + errorMessage);
        System.out.println("");
        System.out.println("========================================<<< * * * * >>>========================================");
        System.out.println("");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
