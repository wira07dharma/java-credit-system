<%-- 
    Document   : useredit_new
    Created on : Dec 27, 2019, 2:31:43 PM
    Author     : arise
--%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.Department"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDepartment"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ page import = "com.dimata.aiso.entity.admin.*" %> 
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
	boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
	if (!privView && !privAdd && !privUpdate && !privDelete) {
		response.sendRedirect(approot + "/nopriv.html");
	}
%>
<%!
    public static String textHeader[][] = {
        {"Pengguna", "Sistem Admin"},
        {"User", "Admin System"}
    };
    public static String textSectionHeader[][] = {
        {"Detail Pengguna", "Assign Pengguna"},
        {"User Detail", "Assign User"}
    };
    public static String textCrud[][] = {
        {"Tambah", "Ubah", "Hapus", "Simpan", "Kembali", "Pilih"},
        {"Add", "Update", "Delete", "Save", "Back", "Select"}
    };
    public static String strTitle[][] = {
        {"Login ID", "Password", "Konfirmasi Password", "Nama", "Email", "Keterangan", "Status User", "Dimasukkan ke Grup", "Ubah", "Tambah", "Lokasi Transaksi", "Departmen", "Kelompok Pemakai", "Lokasi Utama", "Karyawan"},
        {"Login ID", "Password", "Confirm Password", "Full Name", "Email", "Description", "User Status", "Group Assigned", "Edit", "Add", "Assign Trans.Location", "Department", "User Group", "Main Location", "Employee"}
    };
    public static String headerListPegawai[][] = {
        {"No", "Kode", "Nama", "Alamat", "Handphone", "Aksi"},
        {"No", "Code", "Name", "Address", "Handphone", "Action"}
    };
    public static final String systemTitle[] = {
        "Operator", "User"
    };

    public static final String userTitle[] = {
        "Input", "Entry"
    };

    public static final String dataTableTitle[][] = {
        {"Tampilkan _MENU_ data per halaman",
            "Data Tidak Ditemukan",
            "Menampilkan halaman _PAGE_ dari _PAGES_",
            "Belum Ada Data",
            "(Disaring dari _MAX_ data)",
            "Pencarian :",
            "Awal",
            "Akhir",
            "Berikutnya",
            "Sebelumnya"},
        {"Display _MENU_ records per page",
            "Nothing found - sorry",
            "Showing page _PAGE_ of _PAGES_",
            "No records available",
            "(filtered from _MAX_ total records)",
            "Search :",
            "First",
            "Last",
            "Next",
            "Previous"}
    };
%>
<%
    /* VARIABLE DECLARATION */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);

    String currPageTitle = userTitle[SESS_LANGUAGE];
    String strAddUser = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveUser = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskUser = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteUser = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackUser = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data User Success" : "Simpan Data Sukses");

    /* GET REQUEST FROM HIDDEN TEXT */
    int iCommand = FRMQueryString.requestCommand(request);
    long appUserOID = FRMQueryString.requestLong(request, "user_oid");
    int start = FRMQueryString.requestInt(request, "start");

    CtrlAppUser ctrlAppUser = new CtrlAppUser(request);
    FrmAppUser frmAppUser = ctrlAppUser.getForm();
    String strMasage = "";
    
    String optAll = "<option value='0'>Semua</option>";
    String optLocation = "";
    String optPosition = "";

    int excCode = ctrlAppUser.action(iCommand, appUserOID);
    AppUser appUser = ctrlAppUser.getAppUser();
    strMasage = ctrlAppUser.getMessage();

    if (iCommand == Command.SAVE && excCode == FRMMessage.NONE) {
        strMasage = saveConfirm;
        iCommand = Command.EDIT;
//		appUser = new AppUser();
    }
    // proses untuk data custom
    if (iCommand == Command.DELETE) {
        response.sendRedirect("userlist_new.jsp");
    }
    
    Employee emp = new Employee();
    if(appUser.getEmployeeId() != 0){
        emp = PstEmployee.fetchFromApi(appUser.getEmployeeId());
    }
    
    String whereClause = PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_STORE;
    Vector listLokasi = PstLocation.getListFromApi(0, 0, whereClause, "");
    Vector allGroups = PstAppGroup.list(0, 0, "", PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME]);
    Vector userCustoms = PstDataCustom.getDataCustom(appUser.getOID());
    Vector groups = SessAppUser.getUserGroup(appUser.getOID());
    Vector<DataCustom> userDeptCustoms = PstDataCustom.getDataCustom(appUser.getOID(), "hrdepartment");
    String orderBy = PstDepartment.fieldNames[PstDepartment.FLD_DEPARTMENT];
    Vector<Department> listDept = PstDepartment.list(0, 0, "", orderBy);

    Vector<Position> listPosition = PstPosition.getListFromApiAll();
    Vector<Location> listLocation = PstLocation.getListFromApiAll();
    
    
    int index = 0;
    for (Location l : listLocation) {
        if (index == 0) {
            optLocation += optAll;
        }
        optLocation += "<option value='" + l.getOID() + "'>" + l.getName() + "</option>";
        index++;
    }
    index = 0;
    for(Position pos : listPosition){
        if (index == 0) {
            optPosition += optAll;
        }
        optPosition += "<option value='" + pos.getOID() + "' " + (emp.getPositionId() == pos.getOID() ? "selected='selected'" : "") + ">" + pos.getPosition() + "</option>";
        index++;
    }

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    <%= textHeader[SESS_LANGUAGE][0]%>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border border-gray">
                        <h3 class="box-title">
                            <%= systemTitle[SESS_LANGUAGE]%>: <span class="text-red"><%= systemTitle[SESS_LANGUAGE]%></span>
                        </h3>
                    </div>
                    <div class="box-body">
                        <form id="frmAppUser" name="frmAppUser" action="useredit_new.jsp" method="get"> 
                            <div class="box box-success">
                                <div class="box-header with-border border-gray">
                                    <h3 class="box-title">
                                        <%= textSectionHeader[SESS_LANGUAGE][0]%></span>
                                    </h3>
                                </div>								
                                <div class="box-body">
                                    <input type="hidden" name="command" value="">
                                    <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                                    <input type="hidden" name="start" value="<%=start%>">
                                    <input type="hidden" name="<%= FrmAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE]%>" 
                                           value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd")%>">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][0]%></label>
                                                <div class="input-group col-md-8">
                                                    <input type="text" class="form-control" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_LOGIN_ID]%>"
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_LOGIN_ID]%>"
                                                           value="<%=appUser.getLoginId()%>" required>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_LOGIN_ID)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][1]%></label>
                                                <div class="input-group col-md-8">
                                                    <input class="form-control" type="password" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_PASSWORD]%>" 
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_PASSWORD]%>" 
                                                           value="<%=appUser.getPassword()%>" required>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_PASSWORD)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][2]%></label>
                                                <div class="input-group col-md-8">
                                                    <input class="form-control" type="password" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_CFRM_PASSWORD]%>" 
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_CFRM_PASSWORD]%>" 
                                                           value="<%=appUser.getPassword()%>" required>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_CFRM_PASSWORD)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][3]%></label>
                                                <div class="input-group col-md-8">
                                                    <input class="form-control" type="text" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_FULL_NAME]%>" 
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_FULL_NAME]%>" 
                                                           value="<%=appUser.getFullName()%>" required>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_FULL_NAME)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][6]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control" 
                                                            id="<%= frmAppUser.fieldNames[frmAppUser.FRM_USER_STATUS]%>"
                                                            name="<%= frmAppUser.fieldNames[frmAppUser.FRM_USER_STATUS]%>">
                                                        <% for (int i = 0; i < AppUser.statusTxt.length; i++) {%>
                                                        <option value="<%= i%>" <%= (appUser.getUserStatus() == i ? "selected" : "")%>><%= AppUser.statusTxt[i]%></option>
                                                        <% }%>
                                                    </select>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_USER_STATUS)%></small>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][14]%></label>
                                                <div class="input-group col-md-8">
                                                    <input class="form-control" type="text" id="NAMA_PEGAWAI" 
                                                           value="<%= emp.getFullName() %>" required readonly="">
                                                    <div id="select-pegawai-btn" class="input-group-addon btn btn-primary">
                                                        <i class="fa fa-search"></i>
                                                    </div>
                                                    <input type="hidden" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_EMPLOYEE_ID]%>" 
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_EMPLOYEE_ID]%>" 
                                                           value="<%= emp.getOID() %>">
                                                </div>
                                                <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_EMPLOYEE_ID)%></small>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][4]%></label>
                                                <div class="input-group col-md-8">
                                                    <input class="form-control" type="text" 
                                                           id="<%=frmAppUser.fieldNames[frmAppUser.FRM_EMAIL]%>" 
                                                           name="<%=frmAppUser.fieldNames[frmAppUser.FRM_EMAIL]%>" 
                                                           value="<%=appUser.getEmail()%>" size="30" required>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_EMAIL)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][12]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control" 
                                                            id="<%= frmAppUser.fieldNames[frmAppUser.FRM_USER_GROUP]%>"
                                                            name="<%= frmAppUser.fieldNames[frmAppUser.FRM_USER_GROUP]%>">
                                                        <% for (int i = 0; i < AppUser.strGroupUser.length; i++) {%>
                                                        <option value="<%= i%>" <%= (appUser.getGroupUser() == i ? "selected" : "")%>><%= AppUser.strGroupUser[i]%></option>
                                                        <% }%>
                                                    </select>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_USER_GROUP)%></small>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][7]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control input-sm select2" multiple="multiple" style="width: 100%;" 
                                                            id="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]%>"
                                                            name="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]%>" >
                                                        <%
                                                            for (int i = 0; i < allGroups.size(); i++) {
                                                                AppGroup ag = (AppGroup) allGroups.get(i);
                                                                String selected = "";
                                                                if (!groups.isEmpty()) {
                                                                    for (int j = 0; j < groups.size(); j++) {
                                                                        AppGroup ags = (AppGroup) groups.get(j);
                                                                        if (ag.getOID() == ags.getOID()) {
                                                                            selected = "selected";
                                                                        }
                                                                    }
                                                                }
                                                                out.println("<option value='" + ag.getOID() + "' " + selected + ">" + ag.getGroupName() + "</option>");
                                                            }

                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][5]%></label>
                                                <div class="input-group col-md-8">
                                                    <textarea class="form-control" name="<%=frmAppUser.fieldNames[frmAppUser.FRM_DESCRIPTION]%>" 
                                                              rows="3" required><%=appUser.getDescription()%></textarea>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_DESCRIPTION)%></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="box box-success">
                                <div class="box-header with-border border-gray">
                                    <h3 class="box-title">
                                        <%= textSectionHeader[SESS_LANGUAGE][1]%></span>
                                    </h3>
                                </div>
                                <div class="box-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][11]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control" 
                                                            id="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP] + "_DEPT"%>"
                                                            name="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP] + "_DEPT"%>" >
                                                        <%
                                                            for (Department dept : listDept) {
                                                                String select = "";
                                                                if (!userDeptCustoms.isEmpty()) {
                                                                    for (DataCustom dc : userDeptCustoms) {
                                                                        if (dept.getOID() == Long.parseLong(dc.getDataValue())) {
                                                                            select = "selected";
                                                                        }
                                                                    }
                                                                }
                                                                out.print("<option value='" + dept.getOID() + "' " + select + ">" + dept.getDepartment() + "</option>");
                                                            }
                                                        %>
                                                    </select>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_ASSIGN_LOCATION_ID)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][13]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control" name="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_ASSIGN_LOCATION_ID]%>">
                                                        <%
                                                            for (int i = 0; i < listLokasi.size(); i++) {
                                                                Location loc = (Location) listLokasi.get(i);
                                                                if(i == 0){
                                                                    out.println("<option value='0'>Semua</option>");
                                                                }
                                                                out.println("<option value=\"" + loc.getOID() + "\" " + (loc.getOID() == appUser.getAssignLocationId() ? "selected" : "") + ">" + loc.getName() + "</option>");
                                                            }
                                                        %>
                                                    </select>
                                                    <small class="form-text text-muted"><%= frmAppUser.getErrorMsg(frmAppUser.FRM_ASSIGN_LOCATION_ID)%></small>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label col-md-4"><%=strTitle[SESS_LANGUAGE][10]%></label>
                                                <div class="input-group col-md-8">
                                                    <select class="form-control input-sm select2" multiple="multiple" style="width: 100%;" 
                                                            id="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP] + "_DC"%>"
                                                            name="<%= FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP] + "_DC"%>" >
                                                        <%
                                                            for (int i = 0; i < listLokasi.size(); i++) {
                                                                Location loc = (Location) listLokasi.get(i);
                                                                String selected = "";
                                                                if (!userCustoms.isEmpty()) {
                                                                    for (int j = 0; j < userCustoms.size(); j++) {
                                                                        DataCustom dc = (DataCustom) userCustoms.get(j);
                                                                        String tempOid = Long.toString(loc.getOID());
                                                                        if (tempOid.equals(dc.getDataValue())) {
                                                                            selected = "selected";
                                                                        }
                                                                    }
                                                                }
                                                                out.println("<option value='" + loc.getOID() + "' " + selected + ">" + loc.getName() + "</option>");
                                                            }

                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </form>
                    </div>
                    <% if (privAdd) {%>
                    <div class="box-footer">
                        <button type="button" id="save-user-btn" class="btn btn-success" value="<%= appUser.getOID()%>">
                            <i class="fa fa-save"></i>&nbsp;
                            <%= textCrud[SESS_LANGUAGE][3]%>
                        </button>
                        <button type="button" id="back-btn" class="btn btn-default" value="<%= appUser.getOID()%>">
                            <i class="fa fa-refresh"></i>&nbsp;
                            <%= textCrud[SESS_LANGUAGE][4]%>
                        </button>
                        <button type="button" id="delete-user-btn" class="btn btn-danger" value="<%= appUser.getOID()%>">
                            <i class="fa fa-trash"></i>&nbsp;
                            <%= textCrud[SESS_LANGUAGE][2]%>
                        </button>
                    </div>
                    <% }%> 
                </div>
            </section>

            <div class="example-modal">
                <div class="modal fade" id="select-pegawai-modal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header" style="background-color: #00A65A; color: white;">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span></button>
                                <h3 class="modal-title judul">Judul</h3>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="box box-success with-border">
                                            <div class="box-header">
                                                <h4 class="box-title">Form Pencarian</h4>
                                            </div>
                                            <div class="box-body">
                                                <form id="SEARCH_FORM_PEGAWAI">
                                                    <div class="form-group">
                                                        <label>Posisi</label>
                                                        <select class="form-control select2" id="POSITION_ID" name="POSITION_ID" style="width: 100%;">
                                                            <%= optPosition %>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Lokasi</label>
                                                        <select class="form-control" id="LOKASI_ID" name="LOKASI_ID">
                                                            <%= optLocation %>
                                                        </select>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="box box-success">
                                            <div class="box-header">
                                                <h4 class="box-title">Data Karyawan</h4>
                                            </div>
                                            <div class="box-body">
                                                <div class="table-pegawai-parent">
                                                    <table id="table-pegawai" class="table table-bordered table-striped table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th class="text-center" style="width: 5%"><%= headerListPegawai[SESS_LANGUAGE][0]%></th>
                                                                <th class="text-center" style="width: 10%"><%= headerListPegawai[SESS_LANGUAGE][1]%></th>
                                                                <th class="text-left" style="width: 20%"><%= headerListPegawai[SESS_LANGUAGE][2]%></th>
                                                                <th class="text-left" style="width: 20%"><%= headerListPegawai[SESS_LANGUAGE][3]%></th>
                                                                <th class="text-center" style="width: 10%"><%= headerListPegawai[SESS_LANGUAGE][5]%></th>
                                                            </tr>
                                                        </thead>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" id="save-penilaian-btn" class="btn btn-success">
                                    <i class="fa fa-save"></i>
                                    <%= textCrud[SESS_LANGUAGE][3]%>
                                </button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->
            </div>
            <!-- /.example-modal -->	

        </div>

        <script>
                $(function () {
                    let strMsg = "<%= strMasage %>";
                    let form = $('#frmAppUser');
                    let modalPegawai = $('#select-pegawai-modal');
                    
                    // DATABLE SETTING
                    function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                        var datafilter = "";
                        var privUpdate = "";
                        let formCari = $('#SEARCH_FORM_PEGAWAI');
                        var url = "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&" + formCari.serialize();
                        $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                        $("#" + elementId).dataTable({
                            "bDestroy": true,
                            "searching": true,
                            "iDisplayLength": 10,
                            "bProcessing": true,
                            "order": [[1]],
                            "pagingType":"simple",
                            "oLanguage": {
                                "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>",
                                        "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
                                        "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
                                        "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
                                        "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
                                        "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
                                        "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>",
                                "oPaginate": {
                                            "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                                            "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                            "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                            "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                                }
                            },
                            "bServerSide": true,
                            "sAjaxSource": url,
                            aoColumnDefs: [
                                {
                                    bSortable: false,
                                    aTargets: [0, -1]
                                }
                            ],
                            "initComplete": function (settings, json) {
                                if (callBackDataTables !== null) {
                                    callBackDataTables();
                                }
                            },
                            "fnDrawCallback": function (oSettings) {
                                if (callBackDataTables !== null) {
                                    callBackDataTables();
                                }
                            },
                            "fnPageChange": function (oSettings) {

                            }
                        });
                        $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                        $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                        $("#" + elementId).css("width", "100%");
                    };
                
                    function runDataTable() {
                        dataTablesOptions("#table-pegawai-parent", "table-pegawai", "AjaxAnggota", "listEmployee", null);
                    };  
                    
                    
                    if(strMsg.length > 0){
                        alert(strMsg);
                    }
                    $('.select2').select2();
                    
                    $('#POSITION_ID').select2({
                       tags: true,
                       dropdownParent: $("#select-pegawai-modal")
                    });

                    $('body').on('click', '#back-btn', function () {
                        let oid = $(this).val();
                        let url = "userlist_new.jsp?command=<%= Command.BACK%>&user_oid=" + oid;
                        window.location = url;
                    });
                    $('body').on('click', '#save-user-btn', function () {
                        document.frmAppUser.command.value = "<%= Command.SAVE%>";
                        form.submit();
                    });
                    $('body').on('click', '#delete-user-btn', function () {
                        if (confirm("Are you sure want to delete? ")) {
                            document.frmAppUser.command.value = "<%= Command.DELETE%>";
                            form.submit();
                        }
                    });
                    $('body').on('click', '#select-pegawai-btn', function(){
                        modalPegawai.modal('show');
                    });

                    $('body').on('change', '#LOKASI_ID', function(){
                        runDataTable();
                    });
                    $('body').on('change', '#POSITION_ID', function(){
                        runDataTable();
                    });
                    modalPegawai.on('shown.bs.modal', function(){
                        runDataTable();
                    });
                    
                    $('body').on('click', '.pilih-pegawai', function(){
                       let oid = $(this).val(); 
                       let nama = $(this).data('name');
                       
                       $('body #NAMA_PEGAWAI').val(nama);
                       $('body #<%=frmAppUser.fieldNames[frmAppUser.FRM_EMPLOYEE_ID]%>').val(oid);
                       
                       modalPegawai.modal('hide');
                    });
                });
        </script>
    </body>
</html>
