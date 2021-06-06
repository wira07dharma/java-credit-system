<%-- 
    Document   : penjamin
    Created on : Jul 8, 2017, 1:24:28 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.masterdata.PstEmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.entity.masterdata.EmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.form.kredit.FrmDokumenPinjaman"%>
<%@page import="com.dimata.sedana.form.kredit.CtrlDokumenPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.DokumenPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstDokumenPinjaman"%> 
<%@page import="com.dimata.aiso.form.masterdata.anggota.CtrlAnggota"%>
<%@page import="com.dimata.sedana.entity.anggota.PengurusKelompok"%>
<%@page import="com.dimata.sedana.entity.penjamin.PersentaseJaminan"%>
<%@page import="com.dimata.sedana.entity.penjamin.PstPersentaseJaminan"%> 
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPenjamin"%>
<%@page import="com.dimata.sedana.entity.kredit.Penjamin"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmAnggota"%>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Vocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstVocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.region.*" %>
<%@page import="com.dimata.aiso.form.masterdata.region.*" %>
<%@ page import="com.dimata.util.blob.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
  
    public static String strTitle[][] = {
        {"Nomor",//0
            "Nama",//1
            "Jenis Kelamin",//2
            "Tempat Lahir",//3
            "Tanggal Lahir",//4
            "Pekerjaan",//5
            "Agensi",//6
            "Alamat Kantor",//7
            "Kota Alamat Kantor",//8
            "Posisi",//9
            "Alamat Asal",//10
            "Kota Asal",//11
            "Propinsi Asal",//12
            "Kabupaten Asal",//13
            "Kecamatan Asal",//14
            "Kelurahan",//15
            "Id Identitas KTP/SIM",//16
            "Masa Brlaku KTP",//17
            "Telepon",//18
            "Hand Phone",//19
            "Email",//20
            "Pendidikan",//21
            "No NPWP",//22
            "Status",//23
            "Nomor Rekening",//24
            "Tanggal Regristrasi"},//25
        {"Member ID",//0
            "Name",//1
            "Sex",//2
            "Birth of Place",//3
            "Birth of Date",//4
            "Vocation",//5
            "Agencies",//6
            "Office Address",//7
            "Address Office City",//8
            "Position",//9
            "Address",//10
            "City",//11
            "Province",//12
            "Regency",//13
            "Sub Regency",//14
            "Ward",//15
            "ID Card",//16
            "Expired Date KTP",//17
            "Telephone",//18
            "Hand Phone",//19
            "Email",//20
            "Education",//21
            "No NPWP",//22
            "Status",//23
            "Rekening Number",//24
            "Regristation Date"}//25
    }; 
 
    public static final String systemTitle[] = {
        "Keluarga", "Family"
    };
%>
<%  // GET OID FROM transaksi_kredit.jsp
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");
    long oidPenjamin = FRMQueryString.requestLong(request, "penjamin_id");
    long oidDokumenPinjaman = FRMQueryString.requestLong(request, "dokumen_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int type = FRMQueryString.requestInt(request, "type");
    long oidRelasi = FRMQueryString.requestLong(request, "relasi_oid");
    long oidAnggotaKeluarga = FRMQueryString.requestLong(request, "keluarga_oid");
    int intHubunganKeluarga = FRMQueryString.requestInt(request, "hubungan_keluarga");
    String keteranganKeluarga = FRMQueryString.requestString(request, "keterangan_keluarga");
    String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
    String errorMessage = FRMQueryString.requestString(request, "errMsg");

    // data pinjaman
    Pinjaman pinjaman = new Pinjaman();
    Anggota nasabah = new Anggota();
    try {
        pinjaman = PstPinjaman.fetchExc(oidPinjaman);
        nasabah = PstAnggota.fetchExc(pinjaman.getAnggotaId());
    } catch (Exception exc) {

    }
    long oidAnggota = nasabah.getOID();

    String[] hubunganKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman/Bibi"};
    String[] gender = {"Laki-laki", "Perempuan"};

    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = systemTitle[SESS_LANGUAGE];
    String strAddAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackAnggota = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";
    String saveConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Data Member Success" : "Simpan Data Sukses");
    int iErrCode = FRMMessage.ERR_NONE;
    AnggotaKeluarga keluarga = new AnggotaKeluarga();
    Anggota a = new Anggota();
    try {
        a = PstAnggota.fetchExc(oidAnggotaKeluarga);
        keluarga = PstAnggotaKeluarga.fetchExc(oidRelasi);
    } catch (Exception exc) {
        System.out.println(exc.getMessage());
    }
    String errMsg = "";
    if(keteranganKeluarga.equals("")){
     keteranganKeluarga = "-";   
    }
    
    CtrlAnggota ctrlAnggota = new CtrlAnggota(request);
    ctrlAnggota.setLanguage(SESS_LANGUAGE);
    iErrCode = ctrlAnggota.ActionFamily(iCommand, oidAnggotaKeluarga, oidAnggota, intHubunganKeluarga, keteranganKeluarga, oidRelasi);

    errMsg = ctrlAnggota.getMessage();
    a = ctrlAnggota.getAnggota();
    FrmAnggota frmAnggota = ctrlAnggota.getForm();

// tabel pasangan
    Vector listPasangan = new Vector();
    if (typeOfCredit.equals("1")){
        listPasangan = SessAnggota.listJoinKeluarga(0, 0, "", "", oidAnggota);
    } else {
        listPasangan = SessAnggota.listPasangan(0, 0, "", "", oidAnggota);
    }
    String pekerjaan = "";
    Anggota pasangan = new Anggota();
    Vocation v = new Vocation();
    if (!listPasangan.isEmpty()) {
        pasangan = (Anggota) listPasangan.get(0);
        try {
            v = PstVocation.fetchExc(pasangan.getVocationId());
            pekerjaan = v.getVocationName();
        } catch (Exception exc) {

        }
    }
    
    
    

    // tabel penjamin
    //Vector listPenjamin = SessAnggota.listAnggotaPenjamin(0, 0, "", "", oidAnggota);
    Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
    AnggotaBadanUsaha penjamin = new AnggotaBadanUsaha();

    // form penjamin    
    Penjamin dataJaminan = new Penjamin();
    if (oidPenjamin != 0) {
        try {
            dataJaminan = PstPenjamin.fetchExc(oidPenjamin);
        } catch (Exception exc) {

        }
    }
    //For Dokumen Pinjaman
    int iErrDoc = FRMMessage.ERR_NONE;
    CtrlDokumenPinjaman ctrlDokumenPinjaman = new CtrlDokumenPinjaman(request);
    iErrDoc = ctrlDokumenPinjaman.action(iCommand, oidDokumenPinjaman);
    FrmDokumenPinjaman frmDokumenPinjaman = ctrlDokumenPinjaman.getForm();
    DokumenPinjaman dokumenPinjaman = ctrlDokumenPinjaman.getDokumenPinjaman();

    Vector file = new Vector(1,1);
     file.add(""+oidDokumenPinjaman);

    session.putValue("SELECTED_FILE", file);
    System.out.println("vectPict.........."+file);
//    FrmAnggota frmAnggota = new FrmAnggota(a);
//    if (type == 1){

//    }

    if(iCommand == Command.SAVE){
        iCommand = Command.NONE;
        response.sendRedirect("penjamin.jsp?pinjaman_id=" + oidPinjaman + "&errMsg=" + errMsg);
    }
    
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>
        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>

        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- AdminLTE App -->
        <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>

        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            table {font-size: 14px}
            .aksi {width: 1%}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
        </style>
        <script language="javascript">
            
            $('.save-btn').click(function(){
                $('.save-btn').attr({"disabled": "true"}).html("Tunggu...");
                alert("Tes");
            });
            
            function cmdSave() {
                    $('.save-btn').attr({"disabled": "true"}).html("Tunggu...");
                    document.form_anggota_keluarga.command.value = "<%=Command.SAVE%>";
                    document.form_anggota_keluarga.action = "penjamin.jsp";
                    document.form_anggota_keluarga.submit();
                    
                }

                function cmdBack() {
                    document.form_anggota_keluarga.command.value = "<%=Command.LIST%>";
                    document.form_anggota_keluarga.action = "penjamin.jsp";
                    document.form_anggota_keluarga.submit();
                }
            
            function cmdSaveDoc() {
                    document.form_dokumen.command.value = "<%=Command.SAVE%>";
                    document.form_dokumen.action = "penjamin.jsp";
                    document.form_dokumen.submit();
                }

                function cmdBackDoc() {
                    document.form_dokumen.command.value = "<%=Command.LIST%>";
                    document.form_dokumen.action = "penjamin.jsp";
                    document.form_dokumen.submit();
                }
                
            function cmdUpload(oidDokumen, oidPinjaman){
                window.open("<%=approot%>/masterdata/anggota/file_document.jsp?command="+<%=Command.EDIT%>+"&dokumen_id=" + oidDokumen + "&pinjaman_id=" + oidPinjaman , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");

            }
            function cmdOpen(fileName){
		window.open("<%=approot%>/imgdoc/"+fileName , null);
            }
            
            $(document).ready(function () {
                var approot = "<%= approot%>";

                var getDataFunction = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
                    /*
                     * getDataFor	: # FOR PROCCESS FILTER
                     * onDone	: # ON DONE FUNCTION,
                     * onSuccess	: # ON ON SUCCESS FUNCTION,
                     * approot	: # APPLICATION ROOT,
                     * dataSend	: # DATA TO SEND TO THE SERVLET,
                     * servletName  : # SERVLET'S NAME
                     */
                    $(this).getData({
                        onDone: function (data) {
                            onDone(data);
                        },
                        onSuccess: function (data) {
                            onSuccess(data);
                        },
                        approot: approot,
                        dataSend: dataSend,
                        servletName: servletName,
                        dataAppendTo: dataAppendTo,
                        notification: notification
                    });
                };

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var oid = "0";
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_OID_RESERVATION=" + oid,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [-1]
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
                }

                function runDataTable() {
                    dataTablesOptions("#nasabahTableElement", "tableNasabahTableElement", "AjaxAnggota", "listPenjamin", null);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });

                //check required on enter
                function pressEnter(elementIdEnter, elementIdFocus) {
                    $(elementIdEnter).keypress(function (e) {
                        if (e.keyCode === 13) {
                            var atr = $(elementIdEnter).attr('required');
                            var val = $(elementIdEnter).val();
                            if (val === "") {
                                if (atr === "required") {
                                    alert("Data tidak boleh kosong !");
                                    $(elementIdEnter).focus();
                                    return false;
                                }
                            }
                            $(elementIdFocus).focus();
                            return false;
                        }
                    });
                }

                //location.hash = "#btn-savepenjamin";
                $('#NAME').focus();
                pressEnter('.VOCATION_ID', '.POSITION_ID');
                pressEnter('.POSITION_ID', '#OFFICE_ADDRESS');
                pressEnter('#OFFICE_ADDRESS', '.ADDR_OFFICE_CITY');
                pressEnter('.ADDR_OFFICE_CITY', '#NO_NPWP');

                $('#male').click(function () {
                    $('#BIRTH_PLACE').focus();
                });
                $('#female').click(function () {
                    $('#BIRTH_PLACE').focus();
                });

                $('#btn-searchpenjamin').click(function () {
                    var nomor = $('#NO_ANGGOTA').val();
                    modalSetting("#modal-searchpenjamin", "static", false, false);
                    $('#modal-searchpenjamin').modal('show');
                    runDataTable();
                    //$('#modal-searchpenjamin input[type="search"]').val(nomor).keyup();
                });

                $('#btn-searchgeo').click(function () {
                    modalSetting("#modal-geo-area", "static", false, false);
                    $('#modal-geo-area').modal('show');
                });

                $('#btn-addpenjamin').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var idPenjamin = 0;
                    var command = "<%=Command.ADD%>";
                    $('#penjamin_id').val(idPenjamin);
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&penjamin_id=" + idPenjamin;
                });
                
                $('#btn-addDokumen').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.ADD%>";
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&type=2";
                });
                
                $('#btn-addkeluarga').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.ADD%>";
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&type=1";
                });

                $('.btn-viewpenjamin').click(function () {
                    $(this).attr({"disabled": "true"}).html("...");
                    var idPenjamin = $(this).data('oid');
                    var command = "<%=Command.EDIT%>";
                    $('#penjamin_id').val(idPenjamin);
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&penjamin_id=" + idPenjamin;
                });

                $('.btn-viewdokumen').click(function () {
                    $(this).attr({"disabled": "true"}).html("...");
                    var idDokumen = $(this).data('oid');
                    var command = "<%=Command.EDIT%>";
                    $('#dokumen_id').val(idDokumen);
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&dokumen_id=" + idDokumen + "&type=2";
                });                
                
                $('.btn-deleteDokumen').click(function () {
                if(confirm("Are you sure want to delete this?")){
                    $(this).attr({"disabled": "true"}).html("...");
                    var idDokumen = $(this).data('oid');
                    var command = "<%=Command.DELETE%>";
                    $('#dokumen_id').val(idDokumen);
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&dokumen_id=" + idDokumen + "&type=2";
                }
                });

                $('#btn-cancel').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var idPenjamin = $(this).data('oid');
                    var command = "<%=Command.NONE%>";
                    $('#penjamin_id').val(idPenjamin);
                    $('#command').val(command);
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>";
                });

                $('#btn-deletepenjamin').click(function () {
                    var oid = $(this).data('oid');
                    var command = "<%=Command.DELETE%>";
                    $('#penjamin_id').val(oid);
                    $('#command').val(command);
                    var dataFor = "deletePenjamin";
                    var idPinjaman = "<%=oidPinjaman%>";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "SEND_OID_PINJAMAN": idPinjaman,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command
                    };

                    onDone = function (data) {
                        if (data.SEND_ERROR_CODE === 1) {
                            alert(data.SEND_MESSAGE);
                        } else {
                            alert(data.SEND_MESSAGE);
                            command = "<%=Command.NONE%>";
                            var idPenjamin = 0;
                            window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&penjamin_id=" + idPenjamin;
                        }

                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxPenjamin", null, false);
                });

                $('#btn-okgeo').click(function () {
                    var idProvinsi = $('#select-provinsi').val();
                    var idKota = $('#select-kota').val();
                    var idKabupaten = $('#select-kabupaten').val();
                    var idKecamatan = $('#select-kecamatan').val();
                    var idWilayah = $('#select-wilayah').val();
                    $('#oid-provinsi').val(idProvinsi);
                    $('#oid-kota').val(idKota);
                    $('#oid-kabupaten').val(idKabupaten);
                    $('#oid-kecamatan').val(idKecamatan);
                    $('#oid-wilayah').val(idWilayah);
                    //alert(idProvinsi+" "+idKota+" "+idKabupaten+" "+idKecamatan+" "+idWilayah);
                    var nameProvinsi = $('#select-provinsi option:selected').text();
                    var nameKota = $('#select-kota option:selected').text();
                    var nameKabupaten = $('#select-kabupaten option:selected').text();
                    var nameKecamatan = $('#select-kecamatan option:selected').text();
                    var nameWilayah = $('#select-wilayah option:selected').text();
                    //alert(nameProvinsi+" "+nameKota+" "+nameKabupaten+" "+nameKecamatan+" "+nameWilayah);
                    $('#geo-address').val(nameProvinsi + ", " + nameKota + ", " + nameKabupaten + ", " + nameKecamatan + ", " + nameWilayah);
                    $('#modal-geo-area').modal('hide');
                });

                $('body').on("click", ".no-anggota", function () {
                    var oid = $(this).data('oid');
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataAnggota";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command
                    };
                    //alert(dataSend);
                    onDone = function (data) {
                        //alert(JSON.stringify(data.RETURN_DATA_ANGGOTA));
                        $.map(data.RETURN_DATA_ANGGOTA, function (item) {
                            $('#ID_ANGGOTA').val(item.anggota_id);
                            $('#NO_ANGGOTA').val(item.anggota_number);
                            $('#NAME').val(item.anggota_name);
                            if (item.anggota_gender === "<%=PengurusKelompok.GENDER_MALE%>") {
                                $('#male').prop('checked', true);
                                $('#female').prop('checked', false);
                            } else if (item.anggota_gender === "<%=PengurusKelompok.GENDER_FEMALE%>") {
                                $('#female').prop('checked', true);
                                $('#male').prop('checked', false);
                            }
                            $('#BIRTH_PLACE').val(item.anggota_birth_place);
                            $('#BIRTH_DATE').val(item.anggota_birth_date);
                            $('#ADDR_PERMANENT').val(item.anggota_address);
                            $('#geo-address').val(item.anggota_geo_address);
                            $('#TLP').val(item.anggota_telpon);
                            $('#HANDPHONE').val(item.anggota_handphone);
                            $('#EMAIL').val(item.anggota_email);
                            $('#ID_CARD').val(item.anggota_id_card);
                            $('#EXPIRED_DATE_KTP').val(item.anggota_expired_id);
                            $('.VOCATION_ID').val(item.anggota_vocation);
                            $('.POSITION_ID').val(item.anggota_position_id);
                            $('#OFFICE_ADDRESS').val(item.anggota_office_addrs);
                            $('.ADDR_OFFICE_CITY').val(item.anggota_office_city);
                            $('#NO_NPWP').val(item.anggota_npwp);
                            $('#oid-provinsi').val(item.anggota_province);
                            $('#oid-kota').val(item.anggota_city);
                            $('#oid-kabupaten').val(item.anggota_regency);
                            $('#oid-kecamatan').val(item.anggota_subregency);
                            $('#oid-wilayah').val(item.anggota_ward);
                        });
                        $('#prosentase_dijamin').focus();
                    };

                    onSuccess = function (data) {
                        $('#modal-searchpenjamin').modal('hide');
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxAnggota", null, true);
                    return false;
                });

                $('#form-penjamin').submit(function () {
                    var buttonName = $('#btn-savepenjamin').html();
                    $('#btn-savepenjamin').attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $('#ID_ANGGOTA').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "savePenjamin";
                    var prosentase = $('#prosentase_dijamin').val();
                    var idPinjaman = "<%=oidPinjaman%>";
                    var idAnggota = "<%=oidAnggota%>";

                    onDone = function (data) {
                        if (data.SEND_ERROR_CODE === "1") {
                            alert(data.SEND_MESSAGE);
                        } else {
                            alert(data.SEND_MESSAGE);
                            var command = "<%=Command.NONE%>";
                            window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                        }
                    };

                    onSuccess = function (data) {
                        $('#btn-savepenjamin').removeAttr('disabled').html(buttonName);
                    };

                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid
                            + "&SEND_OID_PINJAMAN=" + idPinjaman + "&SEND_OID_ANGGOTA=" + idAnggota + "&SEND_PROSENTASE_DIJAMIN=" + prosentase;
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxPenjamin", null, false);
                    return false;
                });

                //==============================================================

                $('#id_penjaminkredit').focus();
                pressEnter('#id_penjaminkredit', '#view_nilai_prosentase');
                pressEnter('#view_nilai_prosentase', '#btn_save');

                $('#btn_save').click(function () {
                    var idPenjaminKredit = $('#id_penjaminkredit').val();
                    var prosentaseDijamin = $('#nilai_prosentase').val();
                    if (idPenjaminKredit === "") {
                        alert("Pilih penjamin kredit !");
                        $('#id_penjaminkredit').focus();
                    } else if (prosentaseDijamin === "0") {
                        alert("Data prosentase dijamin harus diisi !");
                        $('#view_nilai_prosentase').focus();
                    } else {
                        savePenjamin();
                    }
                });
                
                $('#delete-family').click(function(){
                    var oid = $(this).data('oid');
                    var buttonName = $('#delete-family').html();
                    var command = "<%=Command.DELETE%>";
                    $('#delete-family').attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&keluarga_oid=" + oid;
                            
                });

                $('#btn_delete').click(function () {
                    var buttonName = $('#btn_delete').html();
                    $('#btn_delete').attr({"disabled": "true"}).html("Tunggu...");

                    var oidPenjamin = $('#oid_penjamin').val();
                    var command = "<%=Command.DELETE%>";

                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        var dataSend = {
                            "FRM_FIELD_OID": oidPenjamin,
                            "FRM_FIELD_DATA_FOR": "deletePenjaminKredit",
                            "command": command
                        };
                        onDone = function (data) {
                            if (data.SEND_ERROR_CODE === 1) {
                                alert(data.SEND_MESSAGE);
                            } else {
                                alert("Data penjamin berhasil dihapus");
                                command = "<%=Command.NONE%>";
                                var idPenjamin = 0;
                                window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&penjamin_id=" + idPenjamin;
                            }
                        };
                        onSuccess = function (data) {
                            $('#btn_delete').removeAttr('disabled').html(buttonName);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxPenjamin", null, false);
                        return false;
                    } else {
                        $('#btn_delete').removeAttr('disabled').html(buttonName);
                    }
                });

                function savePenjamin() {
                    var buttonName = $('#btn_save').html();
                    $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

                    var oidPenjamin = $('#oid_penjamin').val();
                    var idPenjaminKredit = $('#id_penjaminkredit').val();
                    var prosentaseDicover = $('#coverage').val();
                    var prosentaseDijamin = $('#nilai_prosentase').val();
                    var command = "<%=Command.SAVE%>";
                    var idTransaksi = $('#oid_transaksi').val();

                    var dataSend = {
                        "FRM_FIELD_OID": oidPenjamin,
                        "FRM_FIELD_DATA_FOR": "savePenjaminKredit",
                        "command": command,
                        "SEND_OID_PENJAMIN": idPenjaminKredit,
                        "SEND_PROSENTASE_COVERAGE": prosentaseDicover,
                        "SEND_PROSENTASE_DIJAMIN": prosentaseDijamin,
                        "SEND_OID_PINJAMAN": "<%=oidPinjaman%>",
                        "SEND_OID_JENIS_TRANSAKSI": idTransaksi
                    };
                    onDone = function (data) {
                        if (data.SEND_ERROR_CODE === "1") {
                            alert(data.SEND_MESSAGE);
                        } else {
                            alert("Data penjamin berhasil disimpan");
                            var command = "<%=Command.NONE%>";
                            window.location = "../penjamin/penjamin.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn_save').removeAttr('disabled').html(buttonName);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxPenjamin", null, false);
                    return false;
                }

                $('.persen_dijamin').click(function () {
                    var idPenjamin = $(this).data('id-penjamin');
                    var nilaiPersen = $(this).data('persen');
                    var idTransaksi = $(this).data('id-transaksi');
                    $('#id_penjaminkredit').val(idPenjamin);
                    $('#view_nilai_prosentase').val(nilaiPersen);
                    jMoney('#view_nilai_prosentase');
                    $('#nilai_prosentase').val(nilaiPersen);
                    $('#oid_transaksi').val(idTransaksi);
                });

                $('#id_penjaminkredit').change(function () {
                    var jenisTransaksi = $('#id_penjaminkredit option:selected').data('jenistransaksi');
                    $('#oid_transaksi').val(jenisTransaksi);
                    var oid = $(this).val();
                    if (oid === "") {
                        $('#coverage').html("<option value=''>Pilih penjamin terlebih dahulu</option>");
                        return false;
                    }
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataCoverage";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SEND_JANGKA_WAKTU": $('#jangkaWaktu').val()
                    };
                    onDone = function (data) {
                        $('#coverage').html(data.FRM_FIELD_HTML);
                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));                    
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxPenjamin", null, false);
                });

                $('#coverage').change(function () {
                    var persen = $('#coverage option:selected').data('persen');
                    $('#view_nilai_prosentase').val(persen);
                    $('#nilai_prosentase').val(persen);
                });

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Pengajuan Kredit
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Pengajuan Kredit</li>
            </ol>
        </section>

        <%if (pinjaman.getOID() != 0) {%>
        <section class="content-header">
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/transaksi_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>&command=<%=Command.EDIT%>">Data Pengajuan</a>
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/jadwal_angsuran.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Jadwal Angsuran</a>
            <a class="btn btn-danger" href="../penjamin/penjamin.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Keluarga & Penjamin</a>
            <% if (typeOfCredit.equals("0")) { %><a style="background-color: white" class="btn btn-default" href="../agunan/agunan.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Agunan / Jaminan</a><% } %>
            <% if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_APPROVED) {%>
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Detail</a>
            <% } %>
            <a style="font-size: 14px" class="btn btn-box-tool" href="../transaksikredit/list_kredit.jsp">Kembali ke daftar kredit</a>
        </section>
        <%} else {%>
        <div class="content-header" style="color: red"><i class="fa fa-warning"></i> &nbsp; Data kredit tidak ditemukan !</div>
        <%}%>

        <section class="content">
            <% if(errorMessage.length() > 0 && errorMessage != null){ %>
            <p class="text-danger" style="font-style: italic">(* <%= errorMessage %></p>
            <% } %>
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgrey">
                    <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>                    
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= nasabah.getOID() %>"><%=nasabah.getName()%></a> &nbsp;(<%=nasabah.getNoAnggota()%>)</h3>
                    <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                </div>
                <% if (typeOfCredit.equals("1")){ %>
                    <div class="box-body">
                        <label>Data Keluarga</label>
                        <table class="table table-bordered table-striped">
                            <tr class="label-success">
                                <th>Nama Keluarga</th>
                                <th>Status Keluarga</th>
                                <th>Pekerjaan</th>                            
                                <th>Telepon</th>
                                <th>Handphone</th>
                                <th>Alamat</th>
                                <th>Action</th>
                            </tr>
                                <%
                                if (!listPasangan.isEmpty()) {
                                    for (int i =0; i < listPasangan.size(); i++){
                                        Anggota ang = (Anggota) listPasangan.get(i);
                                        pekerjaan = "";
                                        v = new Vocation();
                                        try {
                                            v = PstVocation.fetchExc(ang.getVocationId());
                                            pekerjaan = v.getVocationName();
                                        } catch (Exception exc) {

                                        }
                                        
                                        %>
                                        <tr>
                                            <td><%=ang.getName()%></td>
                                            <td><%=hubunganKeluarga[ang.getHubunganKeluarga()]%></td>
                                            <td><%=pekerjaan%></td>                            
                                            <td><%=ang.getTelepon()%></td>
                                            <td><%=ang.getHandPhone()%></td>
                                            <td><%=ang.getAddressPermanent()%></td>
                                            <td class="text-center"><button data-oid="<%=ang.getOID()%>" id="delete-family" class="btn btn-danger"><i class="fa fa-trash"></i></button></td>
                                        </tr>
                                        <%
                                        
                                    }
                                } else {%>
                                <tr>
                                <td colspan="7" class="text-center label-default">Tidak ada data pasangan</td>
                                </tr>
                                <%}%>
                        </table>
                    </div>
                    <div class="box-footer" style="border-color: lightgray">
                        <button type="button" class="btn btn-sm btn-primary" id="btn-addkeluarga"><i class="fa fa-plus"></i> &nbsp; Tambah Keluarga</button>
                    </div>
                 <%} else {%>
                    <div class="box-body">
                        <label>Data Pasangan</label>
                        <table class="table table-bordered table-striped">
                            <tr class="label-success">
                                <th>Nama Pasangan</th>
                                <th>Status Pasangan</th>
                                <th>Pekerjaan</th>                            
                                <th>Telepon</th>
                                <th>Handphone</th>
                                <th>Alamat</th>
                            </tr>
                            <tr>
                                <%if (!listPasangan.isEmpty()) {%>

                                <td><%=pasangan.getName()%></td>
                                <td><%=hubunganKeluarga[pasangan.getHubunganKeluarga()]%></td>
                                <td><%=pekerjaan%></td>                            
                                <td><%=pasangan.getTelepon()%></td>
                                <td><%=pasangan.getHandPhone()%></td>
                                <td><%=pasangan.getAddressPermanent()%></td>

                                <%} else {%>

                                <td colspan="6" class="text-center label-default">Tidak ada data pasangan</td>

                                <%}%>
                            </tr>
                        </table>
                    </div>
                 <% } %>
                <div class="box-body">
                    <label>Daftar Penjamin</label>
                    <table class="table table-bordered table-striped">
                        <tr class="label-success">
                            <th style="width: 40px">No.</th>
                            <th>Nomor Penjamin</th>
                            <th>Nama Penjamin</th>
                            <th>Telepon</th>
                            <th>Email</th>
                            <th>Persentase Coverage</th>
                            <th>Persentase Dibayar</th>
                            <th style="width: 1%">Aksi</th>
                        </tr>

                        <%if (listPenjamin.isEmpty()) {%>

                        <tr><td colspan="8" class="text-center label-default">Tidak ada data penjamin</td></tr>

                        <%} else {
                            for (int i = 0; i < listPenjamin.size(); i++) {
                                Penjamin p = (Penjamin) listPenjamin.get(i);
                                if (!listPenjamin.isEmpty()) {
                                    try {
                                        penjamin = PstAnggotaBadanUsaha.fetchExc(p.getContactId());
                                    } catch (Exception exc) {

                                    }
                                }
                        %>
                        <tr>
                            <td><%=(i + 1)%>.</td>
                            <td><%=penjamin.getNoAnggota()%></td>
                            <td><%=penjamin.getName()%></td>
                            <td><%=penjamin.getTelepon()%></td>
                            <td><%=penjamin.getEmail()%></td>
                            <td class="text-right"><span class="money"><%=p.getCoverage()%></span> %</td>
                            <td class="text-right"><font class="money"><%=p.getProsentasePenjamin()%></font> %</td>
                            <td class="text-center"><button type="button" class="btn btn-xs btn-warning btn-viewpenjamin" data-oid="<%=p.getOID()%>"><i class="fa fa-pencil"></i></button></td>
                        </tr>
                        <%
                                }
                            }
                        %>                        
                    </table>
                </div>
                <%if (pinjaman.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT) || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn-addpenjamin"><i class="fa fa-plus"></i> &nbsp; Tambah Penjamin</button>
                </div>
                <%}%>
                <div class="box-body">
                    <label>Daftar Dokumen</label>
                    <table class="table table-bordered table-striped">
                        <tr class="label-success">
                            <th style="width: 40px">No.</th>
                            <th>Nama Dokumen</th>
                            <th>Nama File</th>
                            <th>Deskripsi</th>
                            <th style="width: 10%">Aksi</th>
                        </tr>

                        <%
                        String fileName = "";
                        String whereDokumen = PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_PINJAMAN_ID] + "=" + oidPinjaman;
                        Vector listDokumen = PstDokumenPinjaman.list(0, 0, whereDokumen, "");
                        if (listDokumen.isEmpty()) {
                        %>
                        <tr><td colspan="8" class="text-center label-default">Tidak ada data dokumen</td></tr>
                        <%
                        } else {
                        for(int i = 0; i < listDokumen.size(); i++){
                        DokumenPinjaman dok = (DokumenPinjaman) listDokumen.get(i);
                        oidDokumenPinjaman = dok.getOID();
                        fileName = dok.getNamaFile();
                        String nameDok = "";
                        String whereClause = PstEmpRelevantDocGroup.fieldNames[PstEmpRelevantDocGroup.FLD_EMP_RELVT_DOC_GRP_ID]+" = "+dok.getNamaDokumen();
                           Vector <EmpRelevantDocGroup> namanya = PstEmpRelevantDocGroup.list(0, 0, whereClause, "");
                           for(EmpRelevantDocGroup relevant : namanya){
                           nameDok = relevant.getDocGroup();
                            }
                        %>
                        <tr>
                            <td><%=i + 1 %></td>
                            <td><a class="btn-viewdokumen" data-oid="<%=oidDokumenPinjaman%>" > <%=nameDok  %></a></td>
                            <%
                            if(fileName.equals("")){
                            %>
                            <td><button type="button" class="btn btn-success btn-xs" onclick="javascript:cmdUpload('<%=dok.getOID() %>','<%=oidPinjaman%>')"><i class="fa fa-upload" > </i> Unggah File</button></td>
                            <%}else{%>
                            <td><%=dok.getNamaFile() %></td>
                            <%}%>
                            <td><%=dok.getDeskripsi() %></td>
                            <td class="text-center">
                                <a href="javascript:cmdOpen('<%=dok.getNamaFile()%>')"><i class="fa fa-eye"></i></a>
                                <a class="btn btn-xs btn-success " href="<%=approot %>/imgdoc/<%=dok.getNamaFile() %>" data-oid="<%=oidDokumenPinjaman %>" download><i class="fa fa-download"></i></a>
                                <a class="btn btn-xs btn-danger btn-deleteDokumen" data-oid="<%=oidDokumenPinjaman %>"><i class="fa fa-trash"></i></a>
                            </td>
                        </tr>
                        <%
                            } 
                            }
                        %>
                    </table>
            </div>
                <%//if (pinjaman.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT) || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn-addDokumen"><i class="fa fa-plus"></i> &nbsp; Tambah Dokumen</button>
                </div>
                <%//}%>

            </div>
            <!--/section-->

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT || type == 1) {%>

            <div class="box box-success">
                <% if (type == 0) {%>
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Form Input Persentase Penjamin</h3>
                </div>

                <p></p>

                <form id="form_penjamin_kredit" class="form-horizontal">
                    <div class="box-body">

                        <input type="hidden" id="oid_penjamin" value="<%=oidPenjamin%>">
                        <input type="hidden" id="oid_pinjaman" value="<%=oidPinjaman%>">
                        <input type="hidden" id="oid_transaksi" value="<%=dataJaminan.getJenisTransaksiId()%>">

                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Janka Waktu Kredit</label>
                                <div class="col-sm-8">
                                    <div class="input-group">
                                        <input type="text" readonly="" id="jangkaWaktu" class="form-control input-sm" value="<%=pinjaman.getJangkaWaktu()%>">
                                        <span class="input-group-addon">Bulan</span>                                        
                                    </div>                                    
                                </div>                                
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Penjamin Kredit</label>
                                <div class="col-sm-8">
                                    <select class="form-control input-sm" id="id_penjaminkredit">
                                        <option value="">- Pilih Penjamin -</option>
                                        <%
                                            Vector listPenjaminKredit = PstAnggotaBadanUsaha.listJoinContactClassPenjamin(0, 0, "", "");
                                            for (int i = 0; i < listPenjaminKredit.size(); i++) {
                                                AnggotaBadanUsaha penjaminMaster = (AnggotaBadanUsaha) listPenjaminKredit.get(i);
                                        %>

                                        <% if (iCommand == Command.EDIT && penjaminMaster.getOID() == dataJaminan.getContactId()) {%>
                                        <option selected="" data-jenistransaksi="<%=penjaminMaster.getIdJenisTransaksi()%>" value="<%=penjaminMaster.getOID()%>"><%=penjaminMaster.getName()%></option>
                                        <% } else {%>
                                        <option data-jenistransaksi="<%=penjaminMaster.getIdJenisTransaksi()%>" value="<%=penjaminMaster.getOID()%>"><%=penjaminMaster.getName()%></option>
                                        <% } %>

                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                                    
                        </div>
                        <div class="col-sm-6">

                            <div class="form-group">
                                <label class="control-label col-sm-4">Persentase Coverage</label>
                                <div class="col-sm-8">
                                    <select class="form-control input-sm" id="coverage">
                                        <% if (iCommand == Command.EDIT) {
                                        %>
                                        <option value="">- Pilih -</option>
                                        <%
                                            Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                                                    + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + dataJaminan.getContactId() + "'"
                                                    + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + pinjaman.getJangkaWaktu() + "'"
                                                    + "", "");
                                            for (int i = 0; i < listCoverage.size(); i++) {
                                                PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
                                                String selected = "";
                                                if (pj.getPersentaseDijamin() == dataJaminan.getProsentasePenjamin()) {
                                                    selected = "selected";
                                                }
                                        %>
                                        <option <%=selected%> data-persen="<%=pj.getPersentaseDijamin()%>" value="<%=pj.getPersentaseCoverage()%>"><%=pj.getPersentaseCoverage()%> %</option>
                                        <%
                                            }
                                        %>

                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Persentase Dibayar</label>
                                <div class="col-sm-8">
                                    <div class="input-group">
                                        <input type="text" required="" readonly="" class="form-control input-sm money" id="view_nilai_prosentase" data-cast-class="valProsentase" value="<%=dataJaminan.getProsentasePenjamin()%>">
                                        <input type="hidden" id="nilai_prosentase" class="valProsentase" value="<%=dataJaminan.getProsentasePenjamin()%>">
                                        <span class="input-group-addon">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%--
        <div class="col-sm-6">
            <table class="table table-striped">
                <tr>
                    <th class="text-left">No.</th>
                    <th class="text-left">Penjamin</th>
                    <th class="text-left">Jangka Waktu</th>
                    <th class="text-right">Coverage</th>
                    <th class="text-right">Jaminan</th>
                </tr>

                                <%
                                    String where = "";
                                    if (pinjaman.getJangkaWaktu() < 12) {
                                        where += "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '12'";
                                    } else {
                                        where += "(" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " >= '" + (pinjaman.getJangkaWaktu() - 12) + "'"
                                                + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " <= '" + (pinjaman.getJangkaWaktu() + 12) + "'"
                                                + ")";
                                    }
                                    Vector listPersentasePenjamin = PstPersentaseJaminan.list(0, 0, ""
                                            + where
                                            + " GROUP BY " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + ","
                                            + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_PERSENTASE_COVERAGE], ""
                                            + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " ASC,"
                                            + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_PERSENTASE_COVERAGE] + " ASC");
                                    for (int i = 0; i < listPersentasePenjamin.size(); i++) {
                                        PersentaseJaminan jaminan = (PersentaseJaminan) listPersentasePenjamin.get(i);
                                        AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
                                        try {
                                            abu = PstAnggotaBadanUsaha.fetchExc(jaminan.getIdPenjamin());
                                        } catch (Exception exc) {

                                        }
                                        int jangka = jaminan.getJangkaWaktu() / 12;
                                        String range = "" + jangka;
                                        if (jangka < 1) {
                                            range = "< 1";
                                        }
                                %>                                
                                <tr>
                                    <td><%=(i + 1)%></td>
                                    <td><%=abu.getName()%></td>
                                    <td><%=range%> Tahun</td>
                                    <td class="text-right"><font class="money"><%=jaminan.getPersentaseCoverage()%></font> %</td>
                                    <td class="text-right">
                                        <a href="#" class="persen_dijamin money" data-id-penjamin="<%=abu.getOID()%>" data-id-transaksi="<%=abu.getIdJenisTransaksi()%>" data-nama-transaksi="" data-persen="<%=jaminan.getPersentaseDijamin()%>">
                                            <%=jaminan.getPersentaseDijamin()%>
                                        </a>
                                        <a> %</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </div>
                        --%>
                    </div>
                    <div class="box-footer" style="border-color: lightgray">
                        <div class="col-sm-12">
                            <div class="pull-right">
                                <%if (pinjaman.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED)) {%>
                                <button type="button" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                <%}%>
                                <button type="button" id="btn-cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>                                    
                                <%if (pinjaman.getOID() != 0 && iCommand == Command.EDIT && dataJaminan.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED)) {%>
                                <button type="button" id="btn_delete" class="btn btn-sm btn-danger" data-oid="<%=dataJaminan.getOID()%>"><i class="fa fa-remove"></i> &nbsp; Hapus</button>
                                <%}%>
                            </div>
                        </div>
                    </div>
                </form>
                <% } else if (type == 1 ) { %>
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Input Anggota Keluarga</h3>
                    </div>
                    
                    <p></p>
                    
                    <form name="form_anggota_keluarga" class="form-horizontal">
                        <div class="box-body">
                            <input type="hidden" name="command">
                            <input type="hidden" name="type" value="1">
                            <input type="hidden" name="anggota_oid" value="<%=pinjaman.getAnggotaId()%>">
                            <input type="hidden" name="pinjaman_id" value="<%=oidPinjaman%>">
                            <table  width="98%" align="center" border="0" cellspacing="2" cellpadding="2" bgcolor="#FFF">
                                <tr>
                                    <td valign="top">
                                        <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                            <tr>
                                                <td valign="top" width="100%">
                                                    <% if(useForRaditya.equals("1")){ %>
                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                        <tr>
                                                            <td width="2%" height="20">&nbsp;</td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" class="comment" height="20">
                                                                &nbsp;
                                                            </td>
                                                            <td width="45%" colspan="2" height="20">
                                                                <!-- status dan tanggal registrasi -->
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <!--tanggal registrasi -->
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="30%" height="30">
                                                                            <div align="left"><%=strTitle[SESS_LANGUAGE][25]%></div>
                                                                        </td>
                                                                        <td width="2%">:</td>
                                                                        <td width="58%">
                                                                            <%if (a.getTanggalRegistrasi() != null) {%>
                                                                            <%=Formater.formatDate(a.getTanggalRegistrasi(), "MMM, dd yyyy")%>
                                                                            <%} else {%>
                                                                            <%=Formater.formatDate(new Date(), "MMM, dd yyyy")%>                                                            
                                                                            <%}%>&nbsp;
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_REGRISTATION_DATE]%>" value="<%=a.getTanggalRegistrasi()%>">
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ID_CARD]%>" value="">
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_EMAIL]%>" value="-">
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_PLACE]%>" value="-">
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_DATE]%>" value="<%=a.getTanggalRegistrasi()%>">
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_NPWP]%>" value="-">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <!--status -->
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="30%" height="30">
                                                                            <div align="left"><%=strTitle[SESS_LANGUAGE][23]%></div>
                                                                        </td>
                                                                        <td width="2%">:</td>
                                                                        <td width="58%">
                                                                            <%
                                                                                ControlCombo combo = new ControlCombo();
                                                                                Vector keyStatus = PstAnggota.getStatusKey();
                                                                                Vector valueStatus = PstAnggota.getStatusValue();
                                                                            %>
                                                                            <%=combo.draw(frmAnggota.fieldNames[frmAnggota.FRM_STATUS], "", null, "" + a.getStatus(), valueStatus, keyStatus)%> 
                                                                            * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_STATUS)%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="2%" height="10">&nbsp;</td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" class="comment" height="20">
                                                                &nbsp;
                                                            </td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" height="20">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td height="20">&nbsp;</td>
                                                            <td class="txtheading1" height="20">&nbsp;</td>
                                                            <td class="comment" height="20">
                                                                <div align="left">*) entry required</div>
                                                            </td>
                                                            <td class="txtheading1" height="20">&nbsp;</td>
                                                            <td height="20">&nbsp;</td>
                                                        </tr>
                                                        
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk hubungan keluarga -->
                                                                <div align="left">Hubungan Keluarga</div>
                                                            </td>
                                                            <td>
                                                                <select name="hubungan_keluarga" value="<%=keluarga.getStatusRelasi()%>" class="">
                                                                    <option value="">- Select -</option>
                                                                    <%
                                                                        String[] statusKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman / Bibi"};
                                                                        for (int i = 0; i < statusKeluarga.length; i++) {
                                                                            String selected = "";
                                                                            if (i == keluarga.getStatusRelasi()) {
                                                                                selected = "selected";
                                                                            }
                                                                    %>

                                                                    <option value="<%=i%>" <%=selected%> ><%=statusKeluarga[i]%></option>

                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk No Anggota-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][0]%></div>
                                                            </td>
                                                            <td> 
                                                                <%
                                                                    String noAnggota = "Auto-Number";
                                                                    if (iCommand == Command.EDIT) {
                                                                        noAnggota = a.getNoAnggota();
                                                                    }
                                                                %>
                                                                <input type="text" readonly="" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_ANGGOTA]%>" value="<%=noAnggota%>" class="" maxlength="20" size="40">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                            </td>
                                                             <td ><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                            <td >
                                                                <%
                                                                    ControlCombo comboBox = new ControlCombo();
                                                                    int countVocation = PstVocation.getCount("");
                                                                    Vector listVocation = PstVocation.list(0, countVocation, "", PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME]);
                                                                    Vector vocationKey = new Vector(1, 1);
                                                                    Vector vocationValue = new Vector(1, 1);

                                                                    for (int i = 0; i < listVocation.size(); i++) {
                                                                        Vocation vocation = (Vocation) listVocation.get(i);
                                                                        vocationKey.add(vocation.getVocationName());
                                                                        vocationValue.add(String.valueOf(vocation.getOID()).toString());
                                                                    }
                                                                %>
                                                                <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_VOCATION_ID], "", "select...", "" + a.getVocationId(), vocationValue, vocationKey)%> 
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_VOCATION_ID)%>                                                                                                                               
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk Nama Anggota-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][1]%></div>
                                                            </td>
                                                            <td> 
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NAME_ANGGOTA]%>" value="<%=a.getName()%>" class="" maxlength="50" size="40">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NAME_ANGGOTA)%>
                                                            </td>
                                                            <td valign="top">
                                                                <!-- untuk Alamat Asal -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][10]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PERMANENT]%>" value="<%=(a.getAddressPermanent() != null ? a.getAddressPermanent() : "")%>" size="40" maxlength="50" class="">
                                                                *&nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ADDR_PERMANENT)%>
                                                            </td>
                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top"  >
                                                                <!-- untuk Telepon-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][18]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_TLP]%>" value="<%=a.getTelepon()%>">
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_TLP)%>                                                                                                                                
                                                            </td>
                                                            <td valign="top"  >
                                                                <!-- Untuk Hand Phone-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][19]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_HANDPHONE]%>" value="<%=a.getHandPhone()%>">                                                                                                                            
                                                            </td>

                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top"  height="25">&nbsp;</td>

                                                        </tr>
                                                        <tr align="left">
                                                            <!-- entity hidden -->
                                                            <td valign="top"  height="25">&nbsp;</td>
                                                            <td valign="top"  >
                                                                &nbsp;
                                                            </td>
                                                            <td  valign="top">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top"  >&nbsp;
                                                            </td>
                                                            <td valign="top">&nbsp;                                                                                                                              
                                                            </td>
                                                        </tr>
                                                        <tr align="left">
                                                            <td height="40">&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                        </tr><br><br> 
                                                        <tr align="left">
                                                            <td valign="top"  >&nbsp;</td>
                                                            <td colspan="4"  valign="top"  >
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td> 

                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <%}else{%>
                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" >
                                                        <tr>
                                                            <td width="2%" height="20">&nbsp;</td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" class="comment" height="20">
                                                                &nbsp;
                                                            </td>
                                                            <td width="45%" colspan="2" height="20">
                                                                <!-- status dan tanggal registrasi -->
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <!--tanggal registrasi -->
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="30%" height="30">
                                                                            <div align="left"><%=strTitle[SESS_LANGUAGE][25]%></div>
                                                                        </td>
                                                                        <td width="2%">:</td>
                                                                        <td width="58%">
                                                                            <%if (a.getTanggalRegistrasi() != null) {%>
                                                                            <%=Formater.formatDate(a.getTanggalRegistrasi(), "MMM, dd yyyy")%>
                                                                            <%} else {%>
                                                                            <%=Formater.formatDate(new Date(), "MMM, dd yyyy")%>                                                            
                                                                            <%}%>&nbsp;
                                                                            <input type="hidden" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_REGRISTATION_DATE]%>" value="<%=a.getTanggalRegistrasi()%>">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <!--status -->
                                                                        <td width="5%">&nbsp;</td>
                                                                        <td width="30%" height="30">
                                                                            <div align="left"><%=strTitle[SESS_LANGUAGE][23]%></div>
                                                                        </td>
                                                                        <td width="2%">:</td>
                                                                        <td width="58%">
                                                                            <%
                                                                                ControlCombo combo = new ControlCombo();
                                                                                Vector keyStatus = PstAnggota.getStatusKey();
                                                                                Vector valueStatus = PstAnggota.getStatusValue();
                                                                            %>
                                                                            <%=combo.draw(frmAnggota.fieldNames[frmAnggota.FRM_STATUS], "", null, "" + a.getStatus(), valueStatus, keyStatus)%> 
                                                                            * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_STATUS)%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="2%" height="10">&nbsp;</td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" class="comment" height="20">
                                                                &nbsp;
                                                            </td>
                                                            <td width="15%" class="txtheading1" height="20">&nbsp;</td>
                                                            <td width="35%" height="20">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td height="20">&nbsp;</td>
                                                            <td class="txtheading1" height="20">&nbsp;</td>
                                                            <td class="comment" height="20">
                                                                <div align="left">*) entry required</div>
                                                            </td>
                                                            <td class="txtheading1" height="20">&nbsp;</td>
                                                            <td height="20">&nbsp;</td>
                                                        </tr>
                                                        
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk hubungan keluarga -->
                                                                <div align="left">Hubungan Keluarga</div>
                                                            </td>
                                                            <td>
                                                                <select name="hubungan_keluarga" value="<%=keluarga.getStatusRelasi()%>" class="">
                                                                    <option value="">- Select -</option>
                                                                    <%
                                                                        String[] statusKeluarga = {"Bapak kandung", "Ibu kandung", "Istri", "Suami", "Anak kandung", "Anak tiri", "Saudara kandung", "Saudara tiri", "Sepupu", "Paman / Bibi"};
                                                                        for (int i = 0; i < statusKeluarga.length; i++) {
                                                                            String selected = "";
                                                                            if (i == keluarga.getStatusRelasi()) {
                                                                                selected = "selected";
                                                                            }
                                                                    %>

                                                                    <option value="<%=i%>" <%=selected%> ><%=statusKeluarga[i]%></option>

                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk No Anggota-->
                                                                <div align="left">Keterangan Keluarga</div>
                                                            </td>
                                                            <td>
                                                                <input type="text" name="keterangan_keluarga" value="<%=keluarga.getKeterangan()%>" class="" maxlength="20" size="40">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk No Anggota-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][0]%></div>
                                                            </td>
                                                            <td> 
                                                                <%
                                                                    String noAnggota = "Auto-Number";
                                                                    if (iCommand == Command.EDIT) {
                                                                        noAnggota = a.getNoAnggota();
                                                                    }
                                                                %>
                                                                <input type="text" readonly="" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_ANGGOTA]%>" value="<%=noAnggota%>" class="" maxlength="20" size="40">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_ANGGOTA)%>
                                                            </td>
                                                            <td valign="top"  >
                                                                <!-- Untuk ID Card (KTP)-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][16]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ID_CARD]%>" value="<%=a.getIdCard()%>" class="" size="40" maxlength="50">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ID_CARD)%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk Nama Anggota-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][1]%></div>
                                                            </td>
                                                            <td> 
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NAME_ANGGOTA]%>" value="<%=a.getName()%>" class="" maxlength="50" size="40">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NAME_ANGGOTA)%>
                                                            </td>
                                                            <td valign="top"  >
                                                                <!-- Untuk Email -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][20]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_EMAIL]%>" value="<%=a.getEmail()%>" maxlength="50" size="40" class="">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_EMAIL)%>
                                                            </td>
                                                            <%--<td  valign="top">
                                                                <!-- Untuk Masa Berlaku ID Card-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][17]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <%=ControlDate.drawDate(FrmAnggota.fieldNames[FrmAnggota.FRM_EXPIRED_DATE_KTP], anggota.getExpiredDateKtp(), "", 0, 5)%>                                                                                                                             
                                                            </td>--%>
                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- Untuk Jenis Kelamin -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][2]%></div>
                                                            </td>
                                                            <td>
                                                                <input type="radio" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_SEX]%>" value="<%= PstAnggota.sexValue[PstAnggota.MALE]%>" checked> <%= PstAnggota.sexKey[SESS_LANGUAGE][PstAnggota.MALE]%>
                                                                <input type="radio" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_SEX]%>" value="<%= PstAnggota.sexValue[PstAnggota.FEMALE]%>" <% if (a.getSex() == PstAnggota.sexValue[PstAnggota.FEMALE]) {%> checked <% }%> > <%= PstAnggota.sexKey[SESS_LANGUAGE][PstAnggota.FEMALE]%>
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_SEX)%>                                                                                                                                
                                                            </td>
                                                            <!-- Untuk Pekerjaan -->
                                                            <td ><%=strTitle[SESS_LANGUAGE][5]%></td>
                                                            <td >
                                                                <%
                                                                    ControlCombo comboBox = new ControlCombo();
                                                                    int countVocation = PstVocation.getCount("");
                                                                    Vector listVocation = PstVocation.list(0, countVocation, "", PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME]);
                                                                    Vector vocationKey = new Vector(1, 1);
                                                                    Vector vocationValue = new Vector(1, 1);

                                                                    for (int i = 0; i < listVocation.size(); i++) {
                                                                        Vocation vocation = (Vocation) listVocation.get(i);
                                                                        vocationKey.add(vocation.getVocationName());
                                                                        vocationValue.add(String.valueOf(vocation.getOID()).toString());
                                                                    }
                                                                %>
                                                                <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_VOCATION_ID], "", "select...", "" + a.getVocationId(), vocationValue, vocationKey)%> 
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_VOCATION_ID)%>                                                                                                                               
                                                            </td>
                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td  valign="top"> 
                                                                <!-- untuk tempat lahir-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][3]%></div>
                                                            </td>
                                                            <td>
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_PLACE]%>" value="<%=a.getBirthPlace()%>" class="" size="20">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_BIRTH_PLACE)%>
                                                            </td>
                                                            <td valign="top">
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][7]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_OFFICE_ADDRESS]%>" value="<%=a.getOfficeAddress()%>" size="40" maxlength="50" class="">
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_OFFICE_ADDRESS)%>                                                                                                                           
                                                            </td>
                                                            <!-- untuk Agensi -->
                                                            <!--td>
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][6]%></div>
                                                            </td>
                                                            <td>
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_AGENCIES]%>" value="<%=a.getAgencies()%>" class="" size="20">
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_AGENCIES)%>
                                                            </td-->
                                                        </tr>

                                                        <tr align="left">
                                                            <td valign="top" height="25">&nbsp;</td>
                                                            <td valign="top"  >
                                                                <!-- untuk Tanggal Lahir -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][4]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <%=ControlDate.drawDate(frmAnggota.fieldNames[frmAnggota.FRM_BIRTH_DATE], a.getBirthDate(), "", -17, 110)%>
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_BIRTH_DATE)%>
                                                            </td>
                                                            <td  valign="top">
                                                                <!-- untuk city office -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][8]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <%
                                                                    int countCityKantor = PstCity.getCount("");
                                                                    Vector listCityKantor = PstCity.list(0, countCityKantor, "", PstCity.fieldNames[PstCity.FLD_CITY_NAME]);
                                                                    Vector cityKantorKey = new Vector(1, 1);
                                                                    Vector cityKantorValue = new Vector(1, 1);

                                                                    for (int i = 0; i < listCityKantor.size(); i++) {
                                                                        City city = (City) listCityKantor.get(i);
                                                                        cityKantorKey.add(city.getCityName());
                                                                        cityKantorValue.add(String.valueOf(city.getOID()).toString());
                                                                    }
                                                                %>
                                                                <%=comboBox.draw(frmAnggota.fieldNames[frmAnggota.FRM_ADDR_OFFICE_CITY], "", "select...", "" + a.getAddressOfficeCity(), cityKantorValue, cityKantorKey)%> 
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ADDR_OFFICE_CITY)%>                                                                                                                             
                                                            </td>
                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top">
                                                                <!-- untuk Alamat Asal -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][10]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_ADDR_PERMANENT]%>" value="<%=(a.getAddressPermanent() != null ? a.getAddressPermanent() : "")%>" size="40" maxlength="50" class="">
                                                                *&nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_ADDR_PERMANENT)%>
                                                            </td>
                                                            <td valign="top">
                                                                <!-- no NPWP -->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][22]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_NO_NPWP]%>" value="<%=a.getNoNpwp()%>" maxlength="30" size="40" class="">
                                                                * &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_NO_NPWP)%>                                                                                                                      
                                                            </td>
                                                            <!-- untuk office address -->

                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top"  >
                                                                <!-- untuk Telepon-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][18]%></div>
                                                            </td>
                                                            <td valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_TLP]%>" value="<%=a.getTelepon()%>">
                                                                &nbsp;<%= frmAnggota.getErrorMsg(frmAnggota.FRM_TLP)%>                                                                                                                                
                                                            </td>

                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top" height="25" >&nbsp;</td>
                                                            <td valign="top"  >
                                                                <!-- Untuk Hand Phone-->
                                                                <div align="left"><%=strTitle[SESS_LANGUAGE][19]%></div>
                                                            </td>
                                                            <td  valign="top">
                                                                <input type="text" name="<%=frmAnggota.fieldNames[frmAnggota.FRM_HANDPHONE]%>" value="<%=a.getHandPhone()%>">                                                                                                                            
                                                            </td>

                                                        </tr>
                                                        <tr align="left">
                                                            <td valign="top"  height="25">&nbsp;</td>

                                                        </tr>
                                                        <tr align="left">
                                                            <!-- entity hidden -->
                                                            <td valign="top"  height="25">&nbsp;</td>
                                                            <td valign="top"  >
                                                                &nbsp;
                                                            </td>
                                                            <td  valign="top">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top"  >&nbsp;
                                                            </td>
                                                            <td valign="top">&nbsp;                                                                                                                              
                                                            </td>
                                                        </tr>
                                                        <tr align="left">
                                                            <td height="40">&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                        </tr><br><br> 
                                                        <tr align="left">
                                                            <td valign="top"  >&nbsp;</td>
                                                            <td colspan="4"  valign="top"  >
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td> 

                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <%}%>
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="box-footer" style="border-color: lightgray">
                            <div class="col-sm-12">
                                <div class="pull-right">
                                    <%
                                        ctrLine.setLocationImg(approot + "/image/ctr_line");
                                        ctrLine.initDefault();
                                        ctrLine.setTableWidth("100%");
                                        String scomDel = "javascript:cmdAsk('" + oidAnggotaKeluarga + "')";
                                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidAnggotaKeluarga + "')";
                                        String scancel = "javascript:cmdEdit('" + oidAnggotaKeluarga + "')";

                                        ctrLine.setCommandStyle("command");
                                        ctrLine.setColCommStyle("command");
                                        ctrLine.setCommandStyle("command");
                                        ctrLine.setColCommStyle("command");
                                        ctrLine.setAddStyle("class=\"btn-primary btn-sm\"");
                                        ctrLine.setCancelStyle("class=\"btn-delete btn-sm\"");
                                        ctrLine.setDeleteStyle("class=\"btn-delete btn-sm\"");
                                        ctrLine.setBackStyle("class=\"btn-primary btn-sm\"");
                                        ctrLine.setSaveStyle("class=\"btn-success btn-sm save-btn\"");
                                        ctrLine.setConfirmStyle("class=\"btn-primary btn-sm\"");
                                        ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddAnggota);
                                        //ctrLine.setBackCaption("");
                                        ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                                        ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackAnggota);
                                        ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveAnggota);
                                        ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskAnggota);
                                        ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteAnggota);

                                        ctrLine.setAddCaption(strAddAnggota);
                                        ctrLine.setCancelCaption(strCancel);
                                        ctrLine.setBackCaption(strBackAnggota);
                                        ctrLine.setSaveCaption(strSaveAnggota);
                                        ctrLine.setDeleteCaption(strAskAnggota);
                                        ctrLine.setConfirmDelCaption(strDeleteAnggota);

                                        if (iCommand == Command.EDIT) {
                                            iCommand = Command.EDIT;
                                        }
                                    %> 
                                    <%= ctrLine.draw(iCommand, iErrCode, errMsg)%>
                                </div>
                            </div>
                        </div>
                    </form>
                <% } else {%>
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Input Dokumen Bersangkutan</h3>
            </div>
                    <p></p>
                    <form name="form_dokumen" class="form-horizontal">
                        <div class="box-body">
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="type" value="2">
                            <input type="hidden" name="pinjaman_id" value="<%=oidPinjaman%>">
                            <input type="hidden" name="dokumen_id" value="<%=dokumenPinjaman.getOID() %>">
                            <input type="hidden" id="FRM_FIELD_PINJAMAN_ID" name="<%=frmDokumenPinjaman.fieldNames[frmDokumenPinjaman.FRM_FIELD_PINJAMAN_ID]%>" class="form-control input-sm" value="<%=oidPinjaman %>">
                            <div class="col-md-12">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="col-sm-4 pad-top-5" for="FRM_FIELD_NAMA_DOKUMEN">Nama Dokumen</label>
                                        <div class="col-sm-8">
                                            <select class="form-control input-sm" name="<%=frmDokumenPinjaman.fieldNames[frmDokumenPinjaman.FRM_FIELD_NAMA_DOKUMEN]%>">
                                                <%
                                               Vector <EmpRelevantDocGroup> Group = PstEmpRelevantDocGroup.listAll();
                                               for(EmpRelevantDocGroup empRelevantDocGroup : Group){ %>
                                                <option value="<%=empRelevantDocGroup.getOID() %>"> <%=empRelevantDocGroup.getDocGroup() %> </option>
                                                <% } %>
                                            </select>
                                        </div>
                                    </div>
                                        <%
                                     if((iCommand !=Command.ADD)){
                                        %>
                                    <div class="form-group">
                                        <label class="col-sm-4 pad-top-5" for="FRM_FIELD_NAMA_FILE">File</label>
                                        <div class="col-sm-8">
                                            <input type="hidden" name="<%=frmDokumenPinjaman.fieldNames[frmDokumenPinjaman.FRM_FIELD_NAMA_FILE]%>"  value="<%=dokumenPinjaman.getNamaFile()%>" class="form-control input-sm"> 
                                            <a href="javascript:cmdOpen('<%=dokumenPinjaman.getNamaFile()%>')"><%=dokumenPinjaman.getNamaFile()%></a>
                                            <button type="button" onclick="javascript:cmdUpload('<%=dokumenPinjaman.getOID() %>','<%=oidPinjaman%>')">Unggah File</button>
                                        </div>
                                    </div>
                                        <%}%>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="col-sm-4 pad-top-5" for="FRM_FIELD_DESKRIPSI">Deskripsi</label>
                                        <div class="col-sm-8">
                                            <textarea id="FRM_FIELD_DESKRIPSI" name="<%=frmDokumenPinjaman.fieldNames[frmDokumenPinjaman.FRM_FIELD_DESKRIPSI] %>" class="form-control input-sm"><%=dokumenPinjaman.getDeskripsi() %></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer" style="border-color: lightgray">
                                <a href="javascript:cmdSaveDoc()"  class="btn btn-sm btn-success pull-right"><i class="fa fa-check"></i> &nbsp; Simpan</a>
                                <a href="javascript:cmdBackDoc()" class="btn btn-sm btn-default pull-right"><i class="fa fa-undo"></i> &nbsp; Kembali</a>    
                        </div>
                    </form>
                <%}%>
            </div>

            <%}%>

            <!--------------------------------------------------------------------->

            <div id="modal-searchpenjamin" class="modal fade" role="dialog">
                <div class="modal-dialog modal-lg">                
                    <!-- Modal content-->
                    <div class="modal-content">

                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Cari <%=namaNasabah%></h4>
                        </div>

                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">

                                    <div id="nasabahTableElement">
                                        <table class="table table-striped table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>No. Penjamin</th>
                                                    <th>Nama Penjamin</th>
                                                    <th>Jenis Kelamin</th>
                                                    <th>Tanggal Lahir</th>
                                                    <th>Alamat</th>
                                                    <th>Pekerjaan</th>
                                                    <th>Telepon</th>
                                                    <th>Handphone</th>
                                                    <th class="aksi">Aksi</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                        </div>

                    </div>

                </div>
            </div>

            <div id="modal-geo-area" class="modal fade" role="dialog">
                <div class="modal-dialog modal-sm">                
                    <div class="modal-content">
                        <!--HEADER-->
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Geo Area</h4>
                        </div>
                        <!--BODY-->
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="box-body geo-area-body">

                                        <div class="form-horizontal">

                                            <div class="form-group">
                                                <label class="control-label col-sm-4">Provinsi</label>
                                                <div class="col-sm-8">
                                                    <select class="form-control input-sm" name="" id="select-provinsi">
                                                        <%
                                                            Vector listProvinsi = PstProvince.list(0, 0, "", "");
                                                            for (int i = 0; i < listProvinsi.size(); i++) {
                                                                Province p = (Province) listProvinsi.get(i);
                                                        %>
                                                        <option style="padding: 5px" value="<%=p.getOID()%>"><%=p.getProvinceName()%></option>                                            
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-sm-4">Kota</label>
                                                <div class="col-sm-8">
                                                    <select class="form-control input-sm" name="" id="select-kota">
                                                        <%
                                                            Vector listKota = PstCity.list(0, 0, "", "");
                                                            for (int i = 0; i < listKota.size(); i++) {
                                                                City c = (City) listKota.get(i);
                                                        %>
                                                        <option style="padding: 5px" value="<%=c.getOID()%>"><%=c.getCityName()%></option>                                            
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-sm-4">Kabupaten</label>
                                                <div class="col-sm-8">
                                                    <select class="form-control input-sm" name="" id="select-kabupaten">
                                                        <%
                                                            Vector listKabupaten = PstRegency.list(0, 0, "", "");
                                                            for (int i = 0; i < listKabupaten.size(); i++) {
                                                                Regency r = (Regency) listKabupaten.get(i);
                                                        %>
                                                        <option style="padding: 5px" value="<%=r.getOID()%>"><%=r.getRegencyName()%></option>                                            
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-sm-4">Kecamatan</label>
                                                <div class="col-sm-8">
                                                    <select class="form-control input-sm" name="" id="select-kecamatan">
                                                        <%
                                                            Vector listKecamatan = PstSubRegency.list(0, 0, "", "");
                                                            for (int i = 0; i < listKecamatan.size(); i++) {
                                                                SubRegency s = (SubRegency) listKecamatan.get(i);
                                                        %>
                                                        <option style="padding: 5px" value="<%=s.getOID()%>"><%=s.getSubRegencyName()%></option>                                            
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="control-label col-sm-4">Wilayah</label>
                                                <div class="col-sm-8">
                                                    <select class="form-control input-sm" name="" id="select-wilayah">
                                                        <%
                                                            Vector listWilayah = PstWard.list(0, 0, "", "");
                                                            for (int i = 0; i < listWilayah.size(); i++) {
                                                                Ward w = (Ward) listWilayah.get(i);
                                                        %>
                                                        <option style="padding: 5px" value="<%=w.getOID()%>"><%=w.getWardName()%></option>                                            
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--FOOTER-->
                        <div class="modal-footer">                        
                            <button type="button" id="btn-okgeo" class="btn btn-sm btn-primary">Ok</button>
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>                            
                        </div>

                    </div>
                </div>
            </div>

    </body>
</html>
