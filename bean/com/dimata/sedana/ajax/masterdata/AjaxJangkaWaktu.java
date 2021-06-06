/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.masterdata;

import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.aiso.session.admin.SessUserSession;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.masterdata.JangkaWaktu;
import com.dimata.sedana.entity.masterdata.JangkaWaktuFormula;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktu;
import com.dimata.sedana.entity.masterdata.PstJangkaWaktuFormula;
import com.dimata.sedana.form.masterdata.CtrlJangkaWaktu;
import com.dimata.sedana.form.masterdata.CtrlJangkaWaktuFormula;
import com.dimata.sedana.form.masterdata.FrmJangkaWaktuFormula;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
public class AjaxJangkaWaktu extends HttpServlet {
//DATATABLES

	private String searchTerm;
	private String colName;
	private int colOrder;
	private String dir;
	private int start;
	private int amount;

	//OBJECT
	private JSONObject jSONObject = new JSONObject();

	//LONG
	private long oid = 0;
        private long oidJangkaWaktu = 0;
        private long oidJenisKredit = 0;

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

	//INT
	private int iCommand = 0;
	private int iErrCode = 0;
	private int sessLanguage = 0;
	private int tipeTransaksi = -1;
        private int status = 0;

	private long userId = 0;
	private String userName = "";


	private String masterFormulaForm[][] = {
		{"Jangka Waktu", "Tipe Transaksi", "Formula", "Catatan", "Kode", "Urutan", "Nama Komponen", "Jenis Komponen", "Pembulatan","Jenis Kredit"},
		{"Time Period", "Transaction Type", "Formula", "Note", "Code", "Index", "Comp Name", "Comp Type", "Round Mode", "Credit Type"}
	};

	public static NumberFormat formatNumber = NumberFormat.getInstance(new Locale("id", "ID"));

	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		// OBJECT
		this.jSONObject = new JSONObject();

		//LONG
		this.oid = FRMQueryString.requestLong(request, "MASTER_OID");
                this.oidJangkaWaktu = FRMQueryString.requestLong(request, "OID_JANGKA_WAKTU");
                this.oidJenisKredit = FRMQueryString.requestLong(request, "JENIS_KREDIT_ID");

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
		this.tipeTransaksi = FRMQueryString.requestInt(request, "FRM_FIELD_TIPE_TRANS");
                this.status = FRMQueryString.requestInt(request, "STATUS");

		//OBJECT
		this.jSONObject = new JSONObject();

		this.userId = FRMQueryString.requestLong(request, "SEND_USER_ID");
		this.userName = FRMQueryString.requestString(request, "SEND_USER_NAME");
		
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
		SessUserSession userSession = (SessUserSession) session.getValue(sessionId);
		if (userSession != null) {
			if (userSession.isLoggedIn()) {
				this.sessLogin = true;
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
		if (this.dataFor.equals("listMasterFormula")) {
			String[] cols = {
				"JWF." + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX],
				"JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU],
				"JWF." + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_TRANSACTION_TYPE],
				"JWF." + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_FORMULA],
				""
			};
			jSONObject = listDataTables(request, response, cols, this.dataFor, this.jSONObject);
		} 
	}

	//COMMAND NONE==============================================================
	public void commandNone(HttpServletRequest request, HttpServletResponse response) {
		if (this.dataFor.equals("showMasterFormulaForm")) {
			showMasterFormulaForm(request, response);
		} else if (this.dataFor.equals("calculateSimulation")){
                        calculateSimulation(request, response);
                }
	}

	// COMMAND SAVE ============================================================================
	public void commandSave(HttpServletRequest request, HttpServletResponse response) {
		if (this.dataFor.equals("saveMasterFormula")) {
			saveMasterFormula(request, response);
		} 
	}
	// COMMAND DELETE ============================================================================
	public void commandDelete(HttpServletRequest request, HttpServletResponse response) {
		if (this.dataFor.equals("deleteMasterFormula")) {
			deleteMasterFormula(request, response);
		}  
	}
	
	// COMMAND SAVE
	public void saveMasterFormula(HttpServletRequest request, HttpServletResponse res){
		CtrlJangkaWaktuFormula cjwf = new CtrlJangkaWaktuFormula(request);
		this.iErrCode = cjwf.action(this.iCommand, oid, userId, userName);
//		this.iErrCode = -1;
		long oid = cjwf.getOidRes();
		if (oid != 0) {
			this.message = "Simpan Berhasil.";
			this.iErrCode = 0;
		} else {
			this.message = "Simpan Gagal.\n";
			this.message += cjwf.getMessage();
			this.message += "\nPastikan data dengan benar lalu coba lagi";
		}
	}
	
	// COMMAND DELETE
	public void deleteMasterFormula(HttpServletRequest request, HttpServletResponse res){
		CtrlJangkaWaktuFormula cjwf = new CtrlJangkaWaktuFormula(request);
		cjwf.action(this.iCommand, oid, userId, userName);
		this.iErrCode = -1;
		long oid = cjwf.getOidRes();
		if (oid != 0) {
			this.message = "Hapus Berhasil.";
			this.iErrCode = 0;
		} else {
			this.message = "Hapus Gagal.\n";
			this.message += cjwf.getMessage();
		}
	}
	
	// COMMAND NONE
	public void showMasterFormulaForm(HttpServletRequest request, HttpServletResponse response) {
                long oidJangkaWaktu = FRMQueryString.requestLong(request, "OID_JANGKA_WAKTU");
		JangkaWaktuFormula jwf = new JangkaWaktuFormula();
		if(this.oid != 0){
			try {
				jwf = PstJangkaWaktuFormula.fetchExc(this.oid);
			} catch (Exception e) {
				System.out.println("Error fecth Jang Waktu Formula " + e.getMessage());
			}
		}
		Vector<JangkaWaktu> listJw = PstJangkaWaktu.listAll();
		String optionJw = "";
//		for(JangkaWaktu jw : listJw){
//			optionJw += "<option value=\"" + jw.getOID() + "\"" + (jwf.getJangkaWaktuId()== jw.getOID() ? "selected" : "") + ">" + jw.getJangkaWaktu() + "</option>";
//		}
                
                String optionJenisKredit = "<option value='0'>Global</option>";
                Vector listJenisKredit = PstJenisKredit.list(0, 0, "", "");
                if (listJenisKredit.size()>0){
                    for (int i = 0; i < listJenisKredit.size(); i++){
                        JenisKredit jenisKredit = (JenisKredit) listJenisKredit.get(i);
                        String selected = "";
                        if (this.oid>0){
                            if (jenisKredit.getOID() == jwf.getJenisKreditId()){
                                selected = "selected";
                            }
                        } else {
                            if (jenisKredit.getOID() == oidJenisKredit){
                                selected = "selected";
                            }
                        }
                        optionJenisKredit+= "<option value='"+jenisKredit.getOID()+"' "+selected+">"+jenisKredit.getNamaKredit()+"</option>";
                    }
                }
                
                String optionStatus = "<option value='0'>Aktif</option>"
                        + "<option value='1'>Non Aktif</option>";
                
		String htmlForm = ""
				+ "<input type=\"hidden\" "
				+ "name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JANGKA_WAKTU_FORMULA_ID] + "\" "
				+ "id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JANGKA_WAKTU_FORMULA_ID] + "\""
				+ "value=\"" + jwf.getOID() + "\">"
                                + "<input type=\"hidden\" "
				+ "name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JANGKA_WAKTU_ID] + "\" "
				+ "id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JANGKA_WAKTU_ID] + "\""
				+ "value=\"" + oidJangkaWaktu+ "\">"
                                + "<div class=\"col-md-6\">"
				+ "     <div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][4] + "</label>"
                                + "             <input type=\"text\" "
                                + "                 class=\"form-control\" "
                                + "                 name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_CODE] + "\" "
                                + "                 id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_CODE] + "\" "
                                + "                 value=\""+jwf.getCode()+"\">"
				+ "	</div>"
				+ "</div>"
                                + "<div class=\"col-md-6\">"
				+ "     <div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][6] + "</label>"
				+ "             <input type=\"text\" "
                                + "                 class=\"form-control\" "
                                + "                 name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_COMP_NAME] + "\" "
                                + "                 id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_COMP_NAME] + "\" "
                                + "                 value=\""+jwf.getCompName()+"\">"
				+ "	</div>"
				+ "</div>"
				+ "<div class=\"col-md-6\">"
				+ "	<div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][5] + "</label>"
				+ "             <input type=\"number\" "
                                + "                 class=\"form-control\" "
                                + "                 name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_IDX] + "\" "
                                + "                 id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_IDX] + "\" "
                                + "                 value=\""+jwf.getIdx()+"\">"
				+ "	</div>"
				+ "</div>"
                                + "<div class=\"col-md-6\">"
				+ "	<div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][7] + "</label>"
				+ "		<select class=\"form-control select2\" style=\"width: 100%\""
				+ "				name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_TRANSACTION_TYPE] + "\""
				+ "				id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_TRANSACTION_TYPE] + "\">"
				+ "			<option value=\"" + PstJangkaWaktuFormula.TYPE_NONE + "\""
				+ "					" + (jwf.getTransType() == PstJangkaWaktuFormula.TYPE_NONE ? "selected" : "") + ">" 
				+				PstJangkaWaktuFormula.strTypeComp[PstJangkaWaktuFormula.TYPE_NONE] 
				+ "			</option>"
				+ "			<option value=\"" + PstJangkaWaktuFormula.TYPE_DP + "\""
				+ "					" + (jwf.getTransType() == PstJangkaWaktuFormula.TYPE_DP ? "selected" : "") + ">"
				+				PstJangkaWaktuFormula.strTypeComp[PstJangkaWaktuFormula.TYPE_DP] 
				+ "			</option>"
                                + "			<option value=\"" + PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN + "\""
				+ "					" + (jwf.getTransType() == PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN ? "selected" : "") + ">"
				+				PstJangkaWaktuFormula.strTypeComp[PstJangkaWaktuFormula.TYPE_NILAI_PENGAJUAN] 
				+ "			</option>"
				+ "			</option>"
                                + "			<option value=\"" + PstJangkaWaktuFormula.TYPE_BUNGA + "\""
				+ "					" + (jwf.getTransType() == PstJangkaWaktuFormula.TYPE_BUNGA ? "selected" : "") + ">"
				+				PstJangkaWaktuFormula.strTypeComp[PstJangkaWaktuFormula.TYPE_BUNGA] 
				+ "			</option>"
				+ "			</option>"
                                + "			<option value=\"" + PstJangkaWaktuFormula.TYPE_POKOK + "\""
				+ "					" + (jwf.getTransType() == PstJangkaWaktuFormula.TYPE_POKOK ? "selected" : "") + ">"
				+				PstJangkaWaktuFormula.strTypeComp[PstJangkaWaktuFormula.TYPE_POKOK] 
				+ "			</option>"
				+ "		</select>"
				+ "	</div>"
				+ "</div>"
                                + "<div class=\"col-md-6\">"
				+ "	<div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][8] + "</label>"
				+ "		<select class=\"form-control select2\" style=\"width: 100%\""
				+ "				name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_PEMBULATAN] + "\""
				+ "				id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_PEMBULATAN] + "\">"
				+ "			<option value=\"" + PstJangkaWaktuFormula.TANPA_PEMBULATAN + "\""
				+ "					" + (jwf.getPembulatan()== PstJangkaWaktuFormula.TANPA_PEMBULATAN ? "selected" : "") + ">" 
				+				PstJangkaWaktuFormula.strTypePembulatan[PstJangkaWaktuFormula.TANPA_PEMBULATAN] 
				+ "			</option>"
				+ "			<option value=\"" + PstJangkaWaktuFormula.PEMBULATAN_PULUHAN + "\""
				+ "					" + (jwf.getPembulatan()== PstJangkaWaktuFormula.PEMBULATAN_PULUHAN ? "selected" : "") + ">" 
				+				PstJangkaWaktuFormula.strTypePembulatan[PstJangkaWaktuFormula.PEMBULATAN_PULUHAN] 
				+ "			</option>"
                                + "			<option value=\"" + PstJangkaWaktuFormula.PEMBULATAN_RATUSAN + "\""
				+ "					" + (jwf.getPembulatan()== PstJangkaWaktuFormula.PEMBULATAN_RATUSAN ? "selected" : "") + ">" 
				+				PstJangkaWaktuFormula.strTypePembulatan[PstJangkaWaktuFormula.PEMBULATAN_RATUSAN] 
				+ "			</option>"
                                + "			<option value=\"" + PstJangkaWaktuFormula.PEMBULATAN_RIBUAN + "\""
				+ "					" + (jwf.getPembulatan()== PstJangkaWaktuFormula.PEMBULATAN_RIBUAN ? "selected" : "") + ">" 
				+				PstJangkaWaktuFormula.strTypePembulatan[PstJangkaWaktuFormula.PEMBULATAN_RIBUAN] 
				+ "			</option>"
				+ "		</select>"
				+ "	</div>"
				+ "</div>"
                                + "<div class=\"col-md-6\">"
				+ "	<div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][9] + "</label>"
				+ "		<select class=\"form-control select2\" style=\"width: 100%\""
				+ "				name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JENIS_KREDIT_ID] + "\""
				+ "				id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_JENIS_KREDIT_ID] + "\">"
				+ optionJenisKredit
				+ "		</select>"
				+ "	</div>"
				+ "</div>"
                                + "<div class=\"col-md-6\">"
				+ "	<div class=\"form-group\">"
				+ "		<label>Status</label>"
				+ "		<select class=\"form-control select2\" style=\"width: 100%\""
				+ "				name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_STATUS] + "\""
				+ "				id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_STATUS] + "\">"
				+ optionStatus
				+ "		</select>"
				+ "	</div>"
				+ "</div>"
				+ "<div class=\"col-md-12\">"
				+ "<div class=\"form-group\">"
				+ "		<label>" + masterFormulaForm[sessLanguage][2] + "</label>"
				+ "		<textarea class=\"form-control\" rows=\"3\""
				+ "				name=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_FORMULA] + "\""
				+ "				id=\"" + FrmJangkaWaktuFormula.fieldNames[FrmJangkaWaktuFormula.FRM_FIELD_FORMULA] + "\">" + jwf.getFormula() + "</textarea>"
				+ "		<p class=\"form-text\">"
				+ "			<span class=\"text-bold\">" + masterFormulaForm[sessLanguage][3] + ":</span>"
				+ "			<br>"
				+ "			1. <span class=\"text-bold\">HPP</span> = Harga Rata-rata/Average Price."
				+ "			<br>"
				+ "			2. <span class=\"text-bold\">DP</span> = Jumlah DP(Down Payment)."
				+ "			<br>"
				+ "			3. <span class=\"text-bold\">TOTAL_PRICE</span> = Jumah Pengajuan."
				+ "			<br>"
				+ "			4. <span class=\"text-bold\">INCREASE</span> = Kenaikan harga."
				+ "		</p>"
				+ "</div>"
				+ "</div>";
		this.htmlReturn = htmlForm;
	}
        
        public void calculateSimulation(HttpServletRequest request, HttpServletResponse response) {
                long oidJangkaWaktu = FRMQueryString.requestLong(request, "OID_JANGKA_WAKTU");
                double hpp = FRMQueryString.requestDouble(request, "hpp");
                double dp = FRMQueryString.requestDouble(request, "dp");
                double increase = FRMQueryString.requestDouble(request, "increase");
                long oidJenisKredit = FRMQueryString.requestLong(request, "jKredit");
                
                String whereFormula = PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+oidJangkaWaktu
                        + " AND "+PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]+"= 0";
                if (oidJenisKredit>0){
                    whereFormula += " AND "+PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"="+oidJenisKredit;
                } else {
                    whereFormula += " AND "+PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]+"= 0";
                }
                
                Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        whereFormula, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
                
                
                Hashtable<String, Double> hashFormula = new Hashtable<>();
                double value = 0;
                if (listFormula.size()>0){
                    for (int i = 0; i < listFormula.size(); i ++){
                        JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                        String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                        formula = formula.replaceAll("&gt", ">");
                        formula = formula.replaceAll("&lt", "<");
                        if (checkString(formula, "HPP") > -1) {
                            formula = formula.replaceAll("HPP", "" + hpp);
                        }
                        if (checkString(formula, "DP") > -1) {
                            formula = formula.replaceAll("DP", "" + dp);
                        }
                        if (checkString(formula, "INCREASE") > -1) {
                            formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                        }
                        
                        for(Map.Entry m : hashFormula.entrySet()) {
                            formula = formula.replaceAll(""+m.getKey(), "" + m.getValue());
                        }
                        
                        String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                        if (sComp != null && sComp.length() > 0) {
                            double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,hpp,dp);
                            formula = formula.replaceAll(""+sComp, "" + compVal);
                        }
                        
                        value = getValue(formula);
                        
                        switch(jangkaWaktuFormula.getPembulatan()){
                            case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                                value = rounding(-1, value);
                                break;
                            case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                                value = rounding(-2, value);
                                break;
                            case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                                value = rounding(-3, value);
                                break;
                        }
                        
                        hashFormula.put(jangkaWaktuFormula.getCode(), value);
                        
                    }
                }
                
		String htmlForm = "<div class=\"col-md-12\">"
				+ "<table class=\"table\" width=\"100%\" cellspacing=\"1\" border=\"0\"> "
                                + "     <thead>"
                                + "         <tr>"
                                + "             <th scope=\"col\" width=\"1%\">Indeks</td>"
                                + "             <th scope=\"col\" width=\"10%\">Kode</td>"
				+ "             <th scope=\"col\" width=\"30%\">Nama</td>"
                                + "             <th scope=\"col\" width=\"44%\">Perhitungan</td>"
                                + "             <th scope=\"col\" width=\"15%\">Nilai</td>"
                                + "         </tr>"
                                + "     </thead>"
				+ "     <tbody>";
                                String nilaiPengajuan = "";
				for (int i = 0; i < listFormula.size(); i ++){
                                    JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                                    
                                    String formula = jangkaWaktuFormula.getFormula();
                                    if (checkString(formula, "HPP") > -1) {
                                        formula = formula.replaceAll("HPP", "" + String.format("%,.2f", hpp));
                                    }
                                    if (checkString(formula, "DP") > -1) {
                                        formula = formula.replaceAll("DP", "" + String.format("%,.2f", dp));
                                    }
                                    String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                                    if (sComp != null && sComp.length() > 0) {
                                        double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,hpp,dp);
                                        formula = formula.replaceAll(""+sComp, "" + String.format("%,.2f", compVal));
                                    }
                                    
                                    for(Map.Entry m : hashFormula.entrySet()) {
                                        formula = formula.replaceAll(""+m.getKey(), "" + String.format("%,.2f", m.getValue()));
                                    }
                                    nilaiPengajuan = String.format("%,.2f", hashFormula.get(jangkaWaktuFormula.getCode()));
                                    htmlForm += "<tr>"
                                                + " <td>"+jangkaWaktuFormula.getIdx()+"</td>"
                                                + " <td>"+jangkaWaktuFormula.getCode()+"</td>"
                                                + " <td>"+jangkaWaktuFormula.getCompName()+"</td>"
                                                + " <td>"+formula+"</td>"
                                                + " <td>"+String.format("%,.2f", hashFormula.get(jangkaWaktuFormula.getCode()))+"</td>"
                                            + "</tr>";
                                    

                                }
                                htmlForm += "         </tbody>"
                                        + " </table></div>"
                                        + " <div class=\"col-md-12\">"
                                        + "<h3><b>Nilai Pengajuan : "+nilaiPengajuan+"</b></h3></div>";
		this.htmlReturn = htmlForm;
	}
        
        
        public double getComponentValue(String compName, String formulaPart, double increase, double hpp, double dp){
            double retValue = 0.0;
            
            Vector vLsitComp = null;
            if (compName == null || formulaPart == null) {
                return 0;
            }
            compName = compName.trim();
            formulaPart = formulaPart.trim();
            if (formulaPart.startsWith(compName)) {
                String[] parts = formulaPart.split("#");
                if (parts.length > 0) {
                    vLsitComp = new Vector();
                    for (int i = 1; i < parts.length; i++) {
                        vLsitComp.add(parts[i]);
                    }
                }
            }
            
            Vector vJangkaWaktu = PstJangkaWaktu.list(0, 0, PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]+"='"+vLsitComp.get(0)+"'", "");
            if (vJangkaWaktu.size()>0){
                JangkaWaktu jangkaWaktu = (JangkaWaktu) vJangkaWaktu.get(0);
                
                 Vector listFormula = PstJangkaWaktuFormula.list(0, 0, 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]+"="+jangkaWaktu.getOID(), 
                        PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]);
                
                Hashtable<String, Double> hashFormula = new Hashtable<>();
                double value = 0;
                if (listFormula.size()>0){
                    for (int i = 0; i < listFormula.size(); i ++){
                        JangkaWaktuFormula jangkaWaktuFormula = (JangkaWaktuFormula) listFormula.get(i);
                        String formula = jangkaWaktuFormula.getFormula().replaceAll("%", "/100");
                        formula = formula.replaceAll("&gt", ">");
                        formula = formula.replaceAll("&lt", "<");
                        if (checkString(formula, "HPP") > -1) {
                            formula = formula.replaceAll("HPP", "" + hpp);
                        }
                        if (checkString(formula, "DP") > -1) {
                            formula = formula.replaceAll("DP", "" + dp);
                        }
                        if (checkString(formula, "INCREASE") > -1) {
                            formula = formula.replaceAll("INCREASE", increase + " / 100.0");
                        }
                        
                        for(Map.Entry m : hashFormula.entrySet()) {
                            formula = formula.replaceAll(""+m.getKey(), "" + m.getValue());
                        }
                        
                        String sComp = checkStringStart(formula, "JANGKA_WAKTU");
                        if (sComp != null && sComp.length() > 0) {
                            double compVal = getComponentValue("JANGKA_WAKTU",sComp,increase,hpp,dp);
                            formula = formula.replaceAll(""+sComp, "" + compVal);
                        }
                        
                        value = getValue(formula);
                        
                        switch(jangkaWaktuFormula.getPembulatan()){
                            case PstJangkaWaktuFormula.PEMBULATAN_PULUHAN :
                                value = rounding(-1, value);
                                break;
                            case PstJangkaWaktuFormula.PEMBULATAN_RATUSAN :
                                value = rounding(-2, value);
                                break;
                            case PstJangkaWaktuFormula.PEMBULATAN_RIBUAN :
                                value = rounding(-3, value);
                                break;
                        }
                        
                        hashFormula.put(jangkaWaktuFormula.getCode(), value);
                        if (String.valueOf(vLsitComp.get(1)).equals(jangkaWaktuFormula.getCode())){
                            retValue = value;
                            break;
                        }
                        
                    }
                }
            }
            
            return retValue;
        }
        
        public static Vector listComponent(String compName, String formulaPart, String sPartBy) {
            Vector vLsitComp = null;
            if (compName == null || formulaPart == null) {
                return null;
            }
            compName = compName.trim();
            formulaPart = formulaPart.trim();
            if (formulaPart.startsWith(compName)) {
                String[] parts = formulaPart.split(sPartBy);
                if (parts.length > 0) {
                    vLsitComp = new Vector();
                    for (int i = 1; i < parts.length; i++) {
                        vLsitComp.add(parts[i]);
                    }
                }
            }
            return vLsitComp;
        }
        
        public static String checkStringStart(String strObject, String toCheck) {
            if (toCheck == null || strObject == null) {
                return null;
            }
            if (strObject.startsWith("=")) {
                strObject = strObject.substring(1);
            }

            String[] parts = strObject.split(" ");
            if (parts.length > 0) {
                for (int i = 0; i < parts.length; i++) {
                    String p = parts[i];
                    if (p.trim().startsWith(toCheck.trim())) {
                        return p.trim();
                    };
                }
            }
            return null;
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
		if (dataFor.equals("listMasterFormula")) {
			whereClause += "JWF."+PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + " = " + oidJangkaWaktu
                                +   " AND JWF."+PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS] + " = " + status
                                +        " AND ("
					+ " JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU] + " LIKE '%" + searchTerm + "%'"
					+ " OR JWF." + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_FORMULA] + " LIKE '%" + searchTerm + "%'"
					+ ")";
			if(oidJenisKredit >= 0){
				whereClause += " AND " + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID] + "=" + oidJenisKredit;
			}
		} 

		String colName = cols[col];
		int total = -1;


		if (dataFor.equals("listMasterFormula")) {
			total = PstJangkaWaktuFormula.getCountJoinFormula(whereClause);
		} 

		this.amount = amount;

		this.colName = colName;
		this.dir = dir;
		this.start = start;
		this.colOrder = col;

		try {
			result = getData(total, request, dataFor, whereClause);
		} catch (Exception ex) {
			printErrorMessage(ex.getMessage());
		}

		return result;
	}

	public JSONObject getData(int total, HttpServletRequest request, String datafor, String whereClause) {
		int totalAfterFilter = total;
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();

		String order = "";

		if (this.colOrder >= 0) {
			order += "" + colName + " " + dir + "";
		}

		ArrayList listData = new ArrayList();
		if (datafor.equals("listMasterFormula")) {
			listData = PstJangkaWaktuFormula.listJoinFormula(start, amount, whereClause, order);
		} 
		
		for (int i = 0; i <= listData.size() - 1; i++) {
			JSONArray ja = new JSONArray();
			if (datafor.equals("listMasterFormula")) {
				ArrayList temp = (ArrayList) listData.get(i);
				int type =Integer.parseInt(String.valueOf(temp.get(3)));
				ja.put("<div class='text-center'>" + temp.get(7) + "</div>");
				ja.put("<div class='text-left'>" + temp.get(5) + "</div>");
                                ja.put("<div class='text-left'>" + temp.get(6) + "</div>");
                                ja.put("<div class='text-left'>" + PstJangkaWaktuFormula.strTypeComp[Integer.parseInt(String.valueOf(temp.get(8)))] + "</div>");
				ja.put("<div class='text-left'>" + PstJangkaWaktuFormula.strTypePembulatan[Integer.parseInt(String.valueOf(temp.get(9)))] + "</div>");
				ja.put("<div class='text-left'><p>" + temp.get(4) + "</p></div>");
				String button = ""
						+ "<button type='button' class='btn btn-warning open-modal-master-formula'"
						+ "		value='" + temp.get(1) + "'>"
						+ "	<i class='fa fa-pencil'></i>"
						+ "</button>"
						+ "<span>&nbsp;</span>"
						+ "<button type='button' class='btn btn-danger delete-master-formula'"
						+ "		value='" + temp.get(1) + "'>"
						+ "	<i class='fa fa-trash'></i>"
						+ "</button>";
				ja.put("<div class='text-center'>" + button + "</div>");
				array.put(ja);
			} 
		}
		
		totalAfterFilter = total;
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
        
        public int checkString(String strObject, String toCheck) {
            if (toCheck == null || strObject == null) {
                return -1;
            }
            if (strObject.startsWith("=")) {
                strObject = strObject.substring(1);
            }

            String[] parts = strObject.split(" ");
            if (parts.length > 0) {
                for (int i = 0; i < parts.length; i++) {
                    String p = parts[i];
                    if (toCheck.trim().equalsIgnoreCase(p.trim())) {
                        return i;
                    };
                }
            }
            return -1;
        }
        
        public double getValue(String formula) {
            DBResultSet dbrs = null;
            double compValueX = 0;
            try {
                String sql = "SELECT (" + formula + ")";
                dbrs = DBHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    compValueX = rs.getDouble(1);
                }

                rs.close();
                return compValueX;
            } catch (Exception e) {
                return 0;
            } finally {
                DBResultSet.close(dbrs);
            }
        }
        
        public static double rounding(int scale, double val){
            BigDecimal bDecimal = new BigDecimal(val);
            bDecimal = bDecimal.setScale(scale, RoundingMode.UP);
            return bDecimal.doubleValue();
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
