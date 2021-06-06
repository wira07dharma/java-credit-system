<%-- 
    Document   : form_pembayaran_kredit
    Created on : Sep 12, 2017, 10:32:54 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.sedana.form.kredit.FrmAngsuran"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.util.*"%>
<%@include file = "../../main/javainit.jsp" %>
<%@include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%! 
    public static String textHeader[][] = {
        {"Ganti Kolektor", "Kredit", "Data Kredit", "Form Pencarian"},
        {"Change Collector", "Loan", "Loan Data", "Search Form"}
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
<%  //  
  long tellerShiftId = 0;
  int iCommand = FRMQueryString.requestCommand(request);
  
    String optAll = "<option value='0'>Semua</option>";
    String optLocation = "";
    String optPosition = "";
    String optKolektabilitas = "";

//    ArrayList<Long> listPosition = new ArrayList<Long>();
    long analisPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ANALIS_OID"));
    long kolektorPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KOLEKTOR_OID"));
    long sbkId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_SBK_OID"));
//    listPosition.add(analisPosId);
//    listPosition.add(kolektorPosId);
    optPosition += "<option value='" + kolektorPosId + "'>Kolektor</option>";
    optPosition += "<option value='" + sbkId + "'>Staff Bantuan Kredit</option>";
    optPosition += "<option value='" + analisPosId + "'>Analis</option>";
    
    Vector<Location> listLocation = PstLocation.getListFromApi(0, 0, "", "");
    int index = 0;
    for(Location l : listLocation){
//        if(index == 0){
//            optLocation += optAll;
//        } 
        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+l.getOID());
        if (l.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
            optLocation += "<option value='" + l.getOID() + "'>" + l.getName() + "</option>";
        }
        index++;
    }
  Location loc = new Location();
  if(userLocationId != 0){
      loc = PstLocation.fetchFromApi(userLocationId);
  }
  if (userOID != 0) {
    Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
    if (open.size() < 1) {
      String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/form_pembayaran_kredit.jsp";
      response.sendRedirect(redirectUrl);
    } else {
      tellerShiftId = open.get(0).getOID();
    }
  }
    Vector<PaymentSystem> listPayment = PstPaymentSystem.list(0, 0, "" + PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, "");
    long idPayment = 0;
    if ( ! listPayment.isEmpty()) {
        idPayment = listPayment.get(0).getOID();
    }
    String nomorKredit = FRMQueryString.requestString(request, "nomor_kredit");    

    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
    boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
    String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
    String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
            + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
    Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
    Employee empKolektor = new Employee();
    if (!privAccept && listUserGroup.isEmpty()) {
        JSONArray analisArr = PstEmployee.fetchEmpDivFromApi(userSession.getAppUser().getEmployeeId());
        PstEmployee.convertJsonToObject(analisArr.optJSONObject(0), empKolektor);
    }

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
    <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce the load. -->
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
    <!--script src="../../style/dist/js/g.js" type="text/javascript"></script-->
    <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script src="../../style/lib.js" type="text/javascript"></script>
    <%@include file="../../style/style_kredit.jsp" %>
    
    <style>
      th {
        text-align: center;
        font-weight: normal;
        vertical-align: middle !important;
        background-color: #00a65a;
        color: white;
        padding-right: 8px !important;
      }
      th:after {display: none !important;}
      .aksi {width: 1% !important}
      .check_multi:hover {cursor: pointer}

      /*
      .print-area { visibility: hidden; display: none; }
      .print-area.print-preview { visibility: visible; display: block; }
      @media print
      {
        body * { visibility: hidden; }
        .print-area * { visibility: visible; }
        .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
      }
      */
      print-area { visibility: hidden; display: none; }
      print-area.preview { visibility: visible; display: block; }
      @media print
      {
        body .main-page * { visibility: hidden; display: none; } 
        body print-area * { visibility: visible; }
        body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
      }
    </style>
    <style>
        /* STYLE FAKTUR RADITYA */
        .tabel_info td {padding: 5px;}
        .uangAngka td {padding-bottom: 0px;}
        .uangTerbilang td {padding-top: 0px; padding-bottom: 10px;}
        .pembayaran td {padding: 0px 5px 0px 5px;}
        .tabel_item td {padding: 0px 5px 0px 5px;}
        .tabel_person td {padding: 0px 5px 0px 5px;}
        .tabel_sign_faktur {width: 100%;}
        .tabel_sign_faktur td {width: 25%;text-align: center;}

        /* STYLE NOTA RADITYA */
        .tabel_data {width: 100%; border-color: lightgray;}
        .tabel_data td {text-align: center; border-color: lightgray !important; padding: 2px !important;}
        .tabel_sign_nota {width: 100%;}
        .tabel_sign_nota td {text-align: center;}
    </style>
    <script language="javascript">
               
    function elementPayment(jumlah = 0) {
        return ''
            + ' <tr id="setoran' + jumlah + '">'
            + '     <td>'                  
            + '         <select class="form-control input-sm selectPayment" id="selectPayment' + jumlah + '" data-row="' + jumlah + '" name="FORM_PAYMENT_TYPE">'
            + "             <% 
                            for(Map.Entry<Integer,String> entry : AngsuranPayment.TIPE_PAYMENT.entrySet()) { 
                                String selected = entry.getKey() == AngsuranPayment.TIPE_PAYMENT_CASH ? "selected" : "";
                                out.print("<option "+ selected +" value='"+entry.getKey()+"'>"+entry.getValue()+"</option>"); 
                            }
                            %>"
            + '         </select>'
            + '         <input type="hidden" class="valPaymentType" id="valPaymentType' + jumlah + '" name="FORM_PAYMENT_ID" value="<%=idPayment%>">'
            + '     </td>'
            + '     <td>'
            + '         <input type="text" readonly="" id="keterangan' + jumlah + '" class="form-control input-sm keterangan" data-row="' + jumlah + '">'
            + '         <!--input tambahan untuk payment tabungan-->'
            + '         <input type="hidden" id="oidSimpanan' + jumlah + '" name="FORM_OID_SIMPANAN">'
            + '         <input type="hidden" id="jumlahPenarikan' + jumlah + '" name="FORM_JUMLAH_PENARIKAN_TABUNGAN">'
            + '         <!--input tambahan untuk payment credit/debit card-->'
            + '         <input type="hidden" id="cardNumber' + jumlah + '" name="FORM_CARD_NUMBER">'
            + '         <input type="hidden" id="bankName' + jumlah + '" name="FORM_BANK_NAME">'
            + '         <input type="hidden" id="validate' + jumlah + '" name="FORM_VALIDATE">'
            + '         <!--input tambahan untuk payment credit card-->'
            + '         <input type="hidden" id="cardName' + jumlah + '" name="FORM_CARD_NAME">'
            + '     </td>'
            + '     <td>'
            + '         <input type="text" autocomplete="off" required="" data-cast-class="valJumlahSetoran' + jumlah + '" class="form-control input-sm money inputSetoran" id="inputSetoran' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valJumlahSetoran' + jumlah + ' valSetoran" name="FORM_JUMLAH_SETORAN" value="">'
            + '     </td>'
            + '     <td><button style="color: #dd4b39;" type="button" data-row="' + jumlah + '" class="btn btn-sm btn-default btn_remove_setoran"><i class="fa fa-minus"></i></button></td>'
            + ' </tr>';
    } 

    function elementAngsuran(jumlah = 0) {        
        return ''
            + ' <tr id="angsuran' + jumlah + '">'
            + '     <td class="text-center">'
            + '         <select class="form-control select-jenis-angsuran input-sm jenisAngsuran' + jumlah + '" data-row="' + jumlah + '" name="FRM_FIELD_JENIS_ANGSURAN">'
            + "            <% 
              if(useRaditya == 1){
              for(int ta=0; ta<(JadwalAngsuran.TIPE_ANGSURAN_RADITYA_VALUE.length); ta++) { out.print("<option value='"+JadwalAngsuran.TIPE_ANGSURAN_RADITYA_VALUE[ta]+"'>"+JadwalAngsuran.TIPE_ANGSURAN_RADITYA_TITLE[ta]+"</option>"); } 
              }else{
              for(int ta=0; ta<(JadwalAngsuran.TIPE_ANGSURAN_VALUE.length); ta++) { out.print("<option value='"+JadwalAngsuran.TIPE_ANGSURAN_VALUE[ta]+"'>"+JadwalAngsuran.TIPE_ANGSURAN_TITLE[ta]+"</option>"); } 
              }
            %>"
            + '         </select>'
            + '         <input type="hidden" id="jenisAngsuran' + jumlah + '" name="FRM_FIELD_JENIS_ANGSURAN">'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <div class="input-group">'
            + '             <input type="text" required="" readonly="" class="form-control input-sm jadwal jadwalAngsuran' + jumlah + '">'
            + '             <input type="hidden" class="jadwalAngsuran idJadwal' + jumlah + '" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID]%>">'
            + '             <span class="input-group-addon btn btn-primary btn-searchschedule" data-row="' + jumlah + '"><i class="fa fa-search"></i></span>'
            + '         </div>'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <input type="text" readonly="" data-cast-class="valTotalAngsuran" class="form-control input-sm jumlahAngsuran jumlahAngsuran' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valTotalAngsuran" id="valTotalAngsuran' + jumlah + '">'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <input type="text" readonly="" data-cast-class="valSisaAngsuran" class="form-control input-sm sisaAngsuran" id="sisaAngsuran' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valSisaAngsuran" id="valSisaAngsuran' + jumlah + '" name="FORM_SISA_ANGSURAN">'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <input type="text" readonly="" autocomplete="off" required="" data-cast-class="valDiscPct' + jumlah + '" class="form-control input-sm money inputDicPct" id="inputDicPct' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valDiscPct' + jumlah + '" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT]%>">'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <input type="text" readonly="" autocomplete="off" required="" data-cast-class="valDiscAmount' + jumlah + '" class="form-control input-sm money inputDicAmount" id="inputDicAmount' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valDiscAmount' + jumlah + '" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT]%>">'
            + '     </td>'
            + '     <td class="text-center">'
            + '         <input type="text" autocomplete="off" required="" data-cast-class="valJumlahDibayar' + jumlah + '" class="form-control input-sm money inputAngsuran" id="inputAngsuran' + jumlah + '" data-row="' + jumlah + '">'
            + '         <input type="hidden" class="valJumlahDibayar' + jumlah + ' valAngsuran" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN]%>">'
            + '     </td>'
            + '     <td class="text-center" style="width: 1px">'
            + '         <button style="color: #dd4b39;" type="button" data-row="' + jumlah + '" class="btn btn-sm btn-default btn_remove_angsuran"><i class="fa fa-minus"></i></button>'
            + '     </td>'
            + ' </tr>';
    }
          
    $(document).ready(function () {
        $('#btn_printTransaksi').hide();
        var getDataFunction = function (onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
            $(this).getData({
                onDone: function (data) {
                    onDone(data);
                },
                onSuccess: function (data) {
                onSuccess(data);
                },
                approot: "<%=approot%>",
                dataSend: dataSend,
                servletName: servletName,
                dataAppendTo: dataAppendTo,
                notification: notification
            });
        };
        var getDataFunctionv2 = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
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
                
        //Sweet Alert
        let swalClasses = {
            container: 'container-class',
            popup: 'popup-class',
            header: 'header-class',
            title: 'title-class',
            closeButton: 'close-button-class',
            icon: 'icon-class',
            image: 'image-class',
            content: 'content-class',
            input: 'input-class',
            actions: 'actions-class',
            confirmButton: 'confirm-button-class',
            cancelButton: 'cancel-button-class',
            footer: 'footer-class'
        };
        function fireSwal(position, type, message){
            Swal.fire({
                position: position,
                icon: type,
                title: message,
                customClass: swalClasses
            });
        };
        
        //MODAL SETTING
        var modalSetting = function (elementId, backdrop, keyboard, show) {
            $(elementId).modal({
                backdrop: backdrop,
                keyboard: keyboard,
                show: show
            });
        };
                  
        // DATABLE SETTING
        function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
            $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
            let kolektorId = $('#oid-kolektor').val();
            $("#" + elementId).dataTable({
                "bDestroy": true,
                "iDisplayLength": 10,
                "bProcessing": true,
                "oLanguage": {
                    "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></div>"
                },
                "bServerSide": true,
                "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&SEND_USER_ID=<%=userOID%>"
                        +"&<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_COLLECTOR_ID] %>=" + kolektorId,
                "aoColumnDefs": [
                    {
                        bSortable: false,
                        aTargets: [ - 1]
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
                    $('#tablePinjamanTableElement').find(".money").each(function () {
                        jMoney(this);
                    });
                    
                    if (<%=nomorKredit.length()%> > 0) {
                        $('#tablePinjamanTableElement').find("a.btn-actionkredit").each(function () {
                            var no = $(this).html();
                            if(no == "<%=nomorKredit%>") {
                                $(this).trigger('click');
                            }
                        });
                    }
                },
                "fnPageChange": function (oSettings) {

                }
            });
            $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
            $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
            $("#" + elementId).css("width", "100%");
        }

        function dataTablesOptionsSchedule(elementIdParent, elementId, servletName, dataFor, callBackDataTables, oid, jenis, idScheduleMulti) {
            var datafilter = "";
            var privUpdate = "";
            $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
            $("#" + elementId).dataTable({"bDestroy": true,
                "ordering": false,
                "iDisplayLength": 10,
                "bProcessing": true, "oLanguage": {
                "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></div>"
                },
                "bServerSide": true,
                "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>"
                        + "&FRM_FIELD_OID=" + oid + "&FRM_JENIS_ANGSURAN=" + jenis + "&SEND_OID_MULTI=" + idScheduleMulti,
                "aoColumnDefs": [
                    { 
                        bSortable: false,
                        aTargets: [ - 1]
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
                    $('#tableJadwalTableElement').find(".money").each(function () {
                        jMoney(this);
                    });
                },
                "fnPageChange": function (oSettings) {

                }
            });
            $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
            $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
            $("#" + elementId).css("width", "100%");
        }

        function kolektorDataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
            var datafilter = "";
            var privUpdate = "";
            var searchForm = $('#KOLEKTOR_SEARCH_PARAM');
            var url = "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&" + searchForm.serialize();
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
                "aoColumnDefs": [
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
            dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listPinjamanFinal", null);
        }

        function runDataTableSchedule(oid, jenis, idScheduleMulti) {
            dataTablesOptionsSchedule("#jadwalTableElement", "tableJadwalTableElement", "AjaxJadwalAngsuran", "listSchedule", null, oid, jenis, idScheduleMulti);
        }
               
        function runKolektorDataTable() {
            kolektorDataTablesOptions("#data-kolektor-table-parent", "data-kolektor-table", "AjaxAnggota", "listAssignKolektor", null);
        };
        
        $('#btn-searchkredit').click(function () {
            var nomor = $('#NOMOR_KREDIT').val();
            modalSetting('#modal-searchkredit', 'static', false, false);
            $('#modal-searchkredit').modal('show');
            runDataTable();
            $('#modal-searchkredit input[type="search"]').val(nomor).keyup();            
        });
        $('#angsuranPertama').click(function () {
            $("#biayaLain").css("display", "block");
        });
        
        var jumlahGlobal = 0;
        $('body').on('click', '.btn-searchschedule', function () {
            var idScheduleMulti = "";
            $('#LIST_ANGSURAN').find('.jadwalAngsuran').each(function() {
                if ($(this).val() != "") {
                    idScheduleMulti += (idScheduleMulti.length > 0) ? "," + $(this).val() : $(this).val();
                }
            });
            
            jumlahGlobal = $(this).data('row');
            var jenis = $('.jenisAngsuran' + jumlahGlobal).val();
            console.log(jenis);
            var oid = $('#oid-kredit').val();
            if (oid === "" || oid === "0") {
                alert("Pilih data kredit terlebih dahulu !");
                $('#btn-searchkredit').trigger('click');
                return false;
            }
            modalSetting('#modal-searchschedule', 'static', false, false);
            $("#checkAll").prop("checked", false);
            $('#modal-searchschedule').modal('show');
            runDataTableSchedule(oid, jenis, idScheduleMulti);
        });
                  
        $('body').on('click', '.btn-actionkredit', function () {
            $('.btn-actionkredit').attr({"disabled": "true"});
            var oid = $(this).data('oid');
            var buttonHtml = $(this).html();
            $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID"         : oid,
                "FRM_FIELD_USER_OID"    : "<%= userOID %>",
                "FRM_FIELD_DATA_FOR"    : "generateDendaPerKredit",
                "command"               : "<%= Command.SAVE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                fetchDataKredit(oid);
            };
            onSuccess = function (data) {
                $(this).removeAttr('disabled').html(buttonHtml);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
            return false;
        });
                  
        function fetchDataKredit(oid){
            $('#oid-kredit').val(oid);
            var dataFor = "getDataKredit";
            var command = "<%=Command.NONE%>";
            var dataSend = {
                "FRM_FIELD_OID": oid,
                "FRM_FIELD_DATA_FOR": dataFor,
                "command": command
            };
            onDone = function (data) {
                $.map(data.RETURN_DATA_KREDIT, function (item) {
                    $('#NOMOR_KREDIT').val(item.nomor_kredit);
                    $('#JENIS_KREDIT').val(item.jenis_kredit);
                    $('#NOMOR_NASABAH').val(item.nomor_nasabah);
                    $('#NAMA_NASABAH').val(item.nama_nasabah);
                    $('#ID_NASABAH').val(item.id_nasabah);
                    $('#ALAMAT_NASABAH').val(item.alamat_nasabah);
                    $('#JANGKA_WAKTU').val(item.jangka_waktu);
                    $('#JENIS_BUNGA').val(item.jenis_bunga);
                    $('#VAL_JUMLAH_PINJAMAN').val(item.jumlah_pinjaman);
                    $('#JUMLAH_PINJAMAN').val(item.jumlah_pinjaman);
                    jMoney('#JUMLAH_PINJAMAN');
                    $('#VAL_SUKU_BUNGA').val(item.suku_bunga);
                    $('#SUKU_BUNGA').val(item.suku_bunga);
                    jMoney('#SUKU_BUNGA');
                    $('#TGL_PENGAJUAN').val(item.tgl_pengajuan);
                    $('#TGL_REALISASI').val(item.tgl_realisasi);
                    $('#TGL_JATUH_TEMPO').val(item.tgl_tempo);
                    $('#ANALIS').val(item.analis);
                    $('#KOLEKTOR').val(item.kolektor);
                    //
                    $('#totalPokok').html(item.total_pokok);
                    jMoney('#totalPokok');
                    $('#totalBunga').html(item.total_bunga);
                    jMoney('#totalBunga');
                    $('#totalDenda').html(item.total_denda);
                    jMoney('#totalDenda');
                    $('#sisaPokok').html(item.sisa_pokok);
                    if (item.sisa_pokok != 0) {
                        $('#sisaPokok').addClass("text-red text-bold");
                    } else {
                        $('#sisaPokok').removeClass("text-red text-bold");
                    }
                    jMoney('#sisaPokok');
                    $('#sisaBunga').html(item.sisa_bunga);
                    if (item.sisa_bunga != 0) {
                        $('#sisaBunga').addClass("text-red text-bold");
                    } else {
                        $('#sisaBunga').removeClass("text-red text-bold");
                    }
                    jMoney('#sisaBunga');
                    $('#sisaDenda').html(item.sisa_denda);
                    if (item.sisa_denda != 0) {
                        $('#sisaDenda').addClass("text-red text-bold");
                    } else {
                        $('#sisaDenda').removeClass("text-red text-bold");
                    }
                    jMoney('#sisaDenda');
                    $(".m-footer").show();

                    if(item.show_btn_dp) {
                        $('#showBtnDP').show();
                    } else {
                        $('#showBtnDP').hide();
                    }

                    $('#LIST_BIAYA').html(data.RETURN_HTML_BIAYA_KREDIT);
                    $('#LIST_BIAYA').find('.money').each(function () {
                        jMoney(this);
                    });

                    if(item.macet!="true") {
                        $(".pelunasan-awal").show();
                        $(".pelunasan-macet").hide();
                        if (<%=nomorKredit.length()%> > 0) {
                            $(".pelunasan-awal").click();
                        }
                    } else {
                        $(".pelunasan-awal").hide();
                        $(".pelunasan-macet").show();
                        if (<%=nomorKredit.length()%> > 0) {
                            $(".pelunasan-macet").click();
                        }
                    }
                    $('#btnCekDendaAngsuran').removeClass('hidden');
                    $('#btnNewSchedule').removeClass('hidden');
                    if (item.sisa_angsuran <= 0 && item.jadwal_belum_dibayar <= 0) {
                        $('#btnPenutupanKredit').removeClass('hidden');
                    }
                });
                $('#btn_clear_angsuran').click();
            };
            onSuccess = function (data) {
                $('#modal-searchkredit').modal('hide');
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }          
                  
        $('body').on('click', '.btn-actionschedule', function () {
            $('.btn-actionschedule').attr({"disabled": "true"});
            var lastRow = $('#jumlah_angsuran').val();
            var oid = $(this).data('oid');
            var sisa = $(this).data('sisa');
            var jenis = $(this).data('jenis');
            $('.idJadwal' + jumlahGlobal).val(oid);
            var dataFor = "getDataAngsuran";
            var command = "<%=Command.NONE%>";
            var dataSend = {
                "FRM_FIELD_OID"         : oid,
                "FRM_FIELD_DATA_FOR"    : dataFor,
                "command"               : command,
                "SEND_LAST_ROW"         : lastRow,
                "SEND_JENIS_ANGSURAN"   : jenis
            };
            onDone = function (data) {               
                /*
                $.map(data.RETURN_DATA_SCHEDULE, function (item) {
                    $('.jadwalAngsuran' + jumlahGlobal).val(item.tgl_angsuran);
                    $('.jumlahAngsuran' + jumlahGlobal).val(item.jumlah_angsuran);
                    $('#sisaAngsuran' + jumlahGlobal).val(sisa);
                    $('#inputAngsuran' + jumlahGlobal).val(sisa);
                    jMoney('.jumlahAngsuran' + jumlahGlobal);
                    jMoney('#sisaAngsuran' + jumlahGlobal);
                    jMoney('#inputAngsuran' + jumlahGlobal);
                    hitungUang();
                });
                */
                if (data.RETURN_ERROR != 0) {
                    alert(data.RETURN_MESSAGE);
                } else {
                    $('#angsuran' + lastRow).remove();
                    var newRow = data.RETURN_LAST_ROW;
                    console.log(newRow);
                    $('#jumlah_angsuran').val(newRow);
                    $('#LIST_ANGSURAN').append(data.FRM_FIELD_HTML);
                    console.log(data.FRM_FIELD_HTML);
                    var arrayRow = data.array_row;
                    $('#LIST_ANGSURAN').find('.money').each(function() {
                        var temp = $(this).data('total');
                        $(this).val(temp);
                        console.log(temp);
                        jMoney(this);
                    });
                    hitungUang();
                    $('#modal-searchschedule').modal('hide');
                }
            };
            onSuccess = function (data) {
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
            return false;
        });
                  
        $('body').on('mousedown', '.selectPayment', function () {
            var oid = $('#ID_NASABAH').val();
            if (oid === "" || oid === "0") {
                alert("Pilih data kredit terlebih dahulu !");
                $('#btn-searchkredit').trigger('click');
                return false;
            }
        });
                          
        $('body').on('change', '.selectPayment', function () {
            var kodePayment = $(this).val();
            var row = $(this).data('row');
            //clear
            $('#keterangan' + row).val("");
            $('#oidSimpanan' + row).val("");
            $('#jumlahPenarikan' + row).val("");
            $('#cardNumber' + row).val("");
            $('#bankName' + row).val("");
            $('#validate' + row).val("");
            $('#cardName' + row).val("");
            
            if (kodePayment === "<%=AngsuranPayment.TIPE_PAYMENT_SAVING%>") {
                getPaymentId(kodePayment, row);
                var oid = $('#ID_NASABAH').val();
                if (oid === "" || oid === "0") {
                    alert("Pilih data kredit terlebih dahulu !");
                    $('#btn-searchkredit').trigger('click');
                    return false;
                } else {
                    modalSetting("#modal-searchtabungan", "static", false, false);
                    $('#modal-searchtabungan').modal('show');
                    var loadBar = "<tr><td colspan='5'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></td></tr>";
                    $('#dataTabelTabungan').html(loadBar);
                    getListTabungan(row);
                }
            } else if (kodePayment === "<%=AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD%>" || kodePayment === "<%=AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD%>") {
                $('#detail_row').val(row);
                modalSetting("#modal-detailPayment", "static", false, false);
                $('#modal-detailPayment').modal('show');
                getListCard(kodePayment);
            } else {
                getPaymentId(kodePayment, row);
            }
        });
        
        function getListCard(kodePayment) {
            var loadBar = "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div>";
            $('#form_body_detail').html(loadBar);
            var dataSend = {
                "SEND_CARA_BAYAR": kodePayment,
                "FRM_FIELD_DATA_FOR": "getListCard",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                $('#form_body_detail').html(data.FRM_FIELD_HTML);
                $('.input_tgl').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }

        $('body').on('dblclick', '.keterangan', function () {
            var row = $(this).data('row');
            var paymentCode = $('#selectPayment' + row).val();
            if (paymentCode === "-1") {
                getPaymentId(paymentCode, row);
                var oid = $('#ID_NASABAH').val();
                if (oid === "" || oid === "0") {
                    alert("Pilih data kredit terlebih dahulu !");
                    $('#btn-searchkredit').trigger('click');
                    return false;
                } else {                   
                    modalSetting("#modal-searchtabungan", "static", false, false);
                    $('#modal-searchtabungan').modal('show');
                    var loadBar = "<tr><td colspan='5'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></td></tr>";
                    $('#dataTabelTabungan').html(loadBar);
                    getListTabungan(row);
                }
            } else if (paymentCode === "<%=AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD%>" || paymentCode === "<%=AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD%>") {
                $('#detail_row').val(row);
                modalSetting("#modal-detailPayment", "static", false, false);
                $('#modal-detailPayment').modal('show');
                getListCard(paymentCode);
            }
        });
        
        $('#form_detail').submit(function () {
            var idPayment = $('#selectKartu').val();
            var namePayment = $('#selectKartu option:selected').text();
            var cardName = $('#namaKartu').val();
            var cardNumber = $('#nomorKartu').val();
            var bankName = $('#namaBank').val();
            var validate = $('#tglValidate').val();
            var row = $('#detail_row').val();
            $('#valPaymentType' + row).val(idPayment);
            $('#keterangan' + row).val(namePayment);
            $('#cardName' + row).val(cardName);
            $('#cardNumber' + row).val(cardNumber);
            $('#bankName' + row).val(bankName);
            $('#validate' + row).val(validate);
            $('#modal-detailPayment').modal('hide');
            return false;
        });
        
        function getListTabungan(row) {
            var idNasabah = $('#ID_NASABAH').val();
            var dataSend = {
                "FRM_FIELD_OID": idNasabah,
                "FRM_FIELD_DATA_FOR": "getListTabungan",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                $('#dataTabelTabungan').html(data.FRM_FIELD_HTML);
                $('#dataTabelTabungan').find('.money').each(function () {
                    jMoney(this);
                });
                $('.btn-pilihtabungan').click(function () {
                    $('.btn-pilihtabungan').attr({"disabled": "true"});
                    var oid = $(this).data('idsimpanan');
                    var noTabungan = $(this).data('notab');
                    var saldoTabungan = $(this).data('saldo');
                    $('#keterangan' + row).val("Nomor Tabungan : " + noTabungan + " " + " | " + " " + "Sisa Saldo : " + saldoTabungan.toLocaleString());
                    $('#oidSimpanan' + row).val(oid);
                    $('#modal-searchtabungan').modal('hide');
                });
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }

        function getPaymentId(kodePayment, row) {
            var dataSend = {
                "SEND_CARA_BAYAR": kodePayment,
                "FRM_FIELD_DATA_FOR": "getIdPayment",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                var error = data.RETURN_ERROR_CODE;
                if (error !== "0") {
                    alert(data.RETURN_MESSAGE);
                }
                $('#valPaymentType' + row).val(data.RETURN_OID_PAYMENT_TYPE);
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
            return false;
        }

        $('#btn_add_setoran').click(function () {
            var jumlah = $('#jumlah_setoran').val();
            jumlah = Number(jumlah) + 1;
            $('#jumlah_setoran').val(jumlah);
            var addHtml = elementPayment(jumlah);
            $('#LIST_SETORAN').append(addHtml);
            $('#setoran' + jumlah).find('.money').each(function () {
                jMoney(this);
            });
            hitungUang();
        });
                          
        $('body').on('click', '.btn_remove_setoran', function () {
            var nilaiJumlah = $(this).data('row');
            $('#setoran' + nilaiJumlah).remove();
            hitungUang();
        });
                          
        $('#btn_add_angsuran').click(function () {
            var jumlah = $('#jumlah_angsuran').val();
            jumlah = Number(jumlah) + 1;
            $('#jumlah_angsuran').val(jumlah);
            $('#LIST_ANGSURAN').append(elementAngsuran(jumlah));
            $('#angsuran' + jumlah).find('.money').each(function () {
                jMoney(this);
            });
            hitungUang();
        });
                          
        $('body').on('click', '.btn_remove_angsuran', function () {
            var nilaiJumlah = $(this).data('row');
            $('#angsuran' + nilaiJumlah).remove();
            hitungUang();
        });
                          
        function hitungUang(row) {
            var jumlah = 0;
            $('.valSetoran').each(function () {
                var nilai = $(this).val();
                console.log("Setoran = " + nilai);
                jumlah += +nilai;
            });
            
            var total = 0;
            console.log($('.valAngsuran'));
            $('.valAngsuran').each(function () {
                var nilai = $(this).val();
                console.log("Angsuran = " + Number.parseFloat(nilai));                
                total += +nilai;                
            });
            
            var biaya = 0;
            $('.valBiaya').each(function () {
                var nilai = $(this).val();
                console.log("Biaya = " + nilai);                
                total += +nilai;
                biaya += +nilai
            });
            
            var disc = 0;
            $('.inputAmountDisc').each(function () {
                var nilai = $(this).val().replace(".","");
                total -= +nilai;
            });
            
            console.log("Jumlah = " + jumlah);
            console.log("Jumlah To Fixed = " + jumlah.toFixed(2));
            console.log("Total = " + total);
            console.log("Total To Fixed = " + total.toFixed(2));
            console.log("Biaya = " + biaya);
            
            jumlah = jumlah.toFixed(2);
            total = total.toFixed(2);
            if (total != jumlah){
                $('#pesan').html("Pastikan jumlah uang sama dengan total angsuran !");
            } else {
                $('#pesan').html("");
            }
            
            $('#jumlahUang').html(jumlah);
            jMoney('#jumlahUang');
            $('#totalBayar').html(total);
            jMoney('#totalBayar');
            var sisa = +jumlah - +total;
            $('#sisaUang').html(sisa);
            jMoney('#sisaUang');
        }
        
        function hitungUangOtomatis(row) {
            var jumlah = 0;
            var total = 0;
            console.log($('.valAngsuran'));
            $('.valAngsuran').each(function () {
                var nilai = $(this).val();
                console.log("Angsuran = " + Number.parseFloat(nilai));                
                total += +nilai;                
            });
            
            var biaya = 0;
            $('.valBiaya').each(function () {
                var nilai = $(this).val();
                console.log("Biaya = " + nilai);                
                total += +nilai;
                biaya += +nilai
            });
            
            var disc = 0;
            $('.inputAmountDisc').each(function () {
                var nilai = $(this).val().replace(".","");
                total -= +nilai;
            });
            
            jumlah = jumlah.toFixed(2);
            total = total.toFixed(2);
            if (total != jumlah){
                $('#pesan').html("Pastikan jumlah uang sama dengan total angsuran !");
            } else {
                $('#pesan').html("");
            }
            
            $('#inputSetoran0').val(total)
            jMoney('#inputSetoran0');
            
            $('#jumlahUang').html(jumlah);
            jMoney('#jumlahUang');
            $('#totalBayar').html(total);
            jMoney('#totalBayar');
            var sisa = +jumlah - +total;
            $('#sisaUang').html(sisa);
            jMoney('#sisaUang');
            hitungUang();
        }

        $('body').on('click', '.jumlahAngsuran', function () {
            var row = $(this).data('row');
            var nilai = $('#valTotalAngsuran' + row).val();
            $('#inputAngsuran' + row).val(nilai);
            jMoney('#inputAngsuran' + row);
        });
                          
        $('body').on('click', '.sisaAngsuran', function () {
            var row = $(this).data('row');
            var nilai = $('#valSisaAngsuran' + row).val();
            $('#inputAngsuran' + row).val(nilai);
            jMoney('#inputAngsuran' + row);
            hitungUang();
        });
                          
        $('body').on('keyup', '.inputSetoran', function () {
            var row = $(this).data('row');
            var jumlah = $('.valJumlahSetoran' + row).val();
            var payType = $('#selectPayment' + row).val();
            if (payType === "<%=AngsuranPayment.TIPE_PAYMENT_SAVING%>") {
                $('#jumlahPenarikan' + row).val(jumlah);
            }
            if (jumlah === "0") {
              $('#inputSetoran' + row).val("");
              hitungUang();
            } else {
              hitungUang();
            }
        });
        
        $('body').on('keyup', '.inputAngsuran', function () {
            var row = $(this).data('row');
            var jumlah = $(this).val();
            if (jumlah === "0") {
                $('#inputAngsuran' + row).val("");
                hitungUang(row);
            } else {
                hitungUang(row);
            }
        });
        
        function cekValidasiForm() {            
            var cekValue = 0;
            //cek id kredit
            var idKredit = $('#oid-kredit').val();
            if (idKredit === "" || idKredit == "" || idKredit === "0" || idKredit == 0) {
                alert("Pastikan nomor kredit dipilih dengan benar !");
                cekValue += 1;
                return false;
            }
            //cek tipe payment
            $('.valPaymentType').each(function () {
                var idPayment = $(this).val();
                if (idPayment === "" || idPayment === "0") {
                    alert("Pastikan cara bayar dipilih dengan benar !");
                    cekValue += 1;
                    return false;
                }
            });
            //cek jadwal angsuran              
            $('.jadwalAngsuran').each(function () {
                var nilai = $(this).val();
                if (nilai === "" || nilai == "" || nilai == 0 || nilai === "0") {
                    alert("Pastikan jadwal sudah dipilih !");
                    cekValue += 1;
                    return false;
                }
            });
            return cekValue;
        }

        $('#FORM_PEMBAYARAN').submit(function () {
            var cekValue = cekValidasiForm();
            if (cekValue > 0) {
                return false;
            } else {
                var buttonHtml = $('#btn_bayar').html();
                $('#btn_bayar').attr({"disabled": "true"}).html("Tunggu...");
                var oid = $('#oid-kredit').val();
                var dataFor = "pembayaranAngsuran";
                var command = "<%=Command.SAVE%>";
                var locationId = "<%= userLocationId %>";
                var dataSend = "FRM_FIELD_OID=" + oid
                + "&FRM_FIELD_DATA_FOR=" + dataFor
                + "&command=" + command
                + "&SEND_OID_TELLER_SHIFT=" + "<%=tellerShiftId%>"
                + "&FRM_FIELD_LOCATION_OID=" + locationId
                + "&SEND_USER_ID=" + "<%= userOID %>";
                onDone = function (data) {
                    var error = data.RETURN_ERROR_CODE;
                    if (error === "0") {
                        var confirmationPay = $('#confirmationPay').val();
                        if (confirmationPay == 0) {
                            modalSetting('#modal-confirm', 'static', false, false);
                            $('#modal-confirm').modal('show');
                            $('#appendBody').html(data.FRM_FIELD_HTML);
                            $('#appendBody').find('.money').each(function() {
                                jMoney(this);
                            });
                        } else {
                            $('#printOut').html(data.FRM_FIELD_HTML);
                            $('#printOut').find(".money").each(function () {
                                jMoney(this);
                            });
                            $('#compName').html("<%= (loc.getName().equals("") ? compName : loc.getName()) %>");
                            $('#compAddr').html("<%= (loc.getAddress().equals("") ? compAddr : loc.getAddress()) %>");
                            $('#compPhone').html("Telp: <%= (loc.getTelephone().equals("") ? compPhone : loc.getTelephone()) %>, Fax: <%= (loc.getFax().equals("") ? compPhone : loc.getFax()) %>");
                            $('#adminCetak').html("<%= userFullName %>");
                            if (confirm("Pembayaran angsuran berhasil.\nCetak bukti transaksi pembayaran ?")) {
                                window.print();
                            }
                            window.location = "../transaksikredit/form_pembayaran_kredit.jsp";
                        }
                    } else {
                        alert(data.RETURN_MESSAGE);
                    }
                };
                onSuccess = function (data) {
                    $('#btn_bayar').removeAttr('disabled').html(buttonHtml);
                };
                var data = $(this).serialize();
                dataSend += "&" + data;
                //alert(JSON.stringify(dataSend));
                getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                return false;
            }
        });
                          
        $(window).keydown(function (event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                return false;
            }
        });
                          
        $(document).on("keydown", function (event) {
            if (event.which === 8 && !$(event.target).is("input, textarea")) {
                event.preventDefault();
            }
        });
        
        $('#allBunga').click(function () {
            var msg = "Yakin ingin melunasi seluruh angsuran bunga ?";
            if (confirm(msg)) {
                var oid = $('#oid-kredit').val();
                if (oid === "" || oid === "0") {
                    alert("Pilih data kredit terlebih dahulu !");
                    $('#btn-searchkredit').trigger('click');
                    return false;
                }
                var jumlahSetoran = 0;
                $('.inputSetoran').each(function () {
                    var nilai = $(this).val();
                    jumlahSetoran += + nilai;
                });
                if (jumlahSetoran <= 0) {
                    alert("Isi jumlah uang setoran terlebih dahulu !");
                    return false;
                }

                var dataSend = "FRM_FIELD_OID=" + oid
                    + "&FRM_FIELD_DATA_FOR=bayarSeluruhAngsuranBunga"
                    + "&command=" + "<%=Command.SAVE%>"
                    + "&SEND_OID_TELLER_SHIFT=" + "<%=tellerShiftId%>";
                
                onDone = function (data) {
                    var error = data.RETURN_ERROR_CODE;
                    if (error === "0") {
                        $('#printOut').html(data.FRM_FIELD_HTML);
                        $('#printOut').find(".money").each(function () {
                            jMoney(this);
                        });
                        $('#compName').html("<%=compName%>");
                        $('#compAddr').html("<%=compAddr%>");
                        $('#compPhone').html("<%=compPhone%>");
                        $('#adminCetak').html("<%=userFullName%>");
                        if (confirm("Pembayaran angsuran berhasil.\nCetak bukti transaksi pembayaran ?")) {
                            window.print();
                        }
                        window.location = "../transaksikredit/form_pembayaran_kredit.jsp";
                    } else {
                        alert(data.RETURN_MESSAGE);
                    }
                };
                onSuccess = function (data) {};
                var data = $('#FORM_PEMBAYARAN').serialize();
                dataSend += "&" + data;
                //alert(JSON.stringify(dataSend));
                getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
            }
        });
                          
        $('#byPriority').click(function () {
            var buttonHtml = $('#byPriority').html();
            var oid = $('#oid-kredit').val();
            var lastRow = $('#jumlah_angsuran').val();
            if (oid === "" || oid === "0") {
                alert("Pilih data kredit terlebih dahulu !");
                $('#btn-searchkredit').trigger('click');
                return false;
            }
            var jumlahSetoran = 0;
            $('.inputSetoran').each(function () {
                var nilai = $(this).val();
                jumlahSetoran += +nilai;
            });
            if (jumlahSetoran <= 0) {
                alert("Isi jumlah uang setoran terlebih dahulu !");                        
                return false;
            }
                    
            $('#byPriority').attr({"disabled": "true"}).html("Tunggu...");
            var dataSend = "FRM_FIELD_OID=" + oid
                + "&FRM_FIELD_DATA_FOR=getPrioritySchedule"
                + "&command=" + "<%=Command.NONE%>"                                
                + "&SEND_LAST_ROW=" + lastRow;
                        
            onDone = function (data) {
                var newRow = data.RETURN_LAST_ROW;
                $('#jumlah_angsuran').val(newRow);
                $('#LIST_ANGSURAN').html(data.FRM_FIELD_HTML);
                $('#LIST_ANGSURAN').find('.money').each(function() {
                    var temp = $(this).data('total');
                    $(this).val(temp);
                    console.log(temp);
                    jMoney(this);
                });
                hitungUang();
            };
            onSuccess = function (data) {
                $('#byPriority').removeAttr('disabled').html(buttonHtml);
            };
            var data = $('#FORM_PEMBAYARAN').serialize();
            dataSend += "&" + data;
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
        });
        
        if (<%=nomorKredit.length()%> > 0) {
            $('#btn-searchkredit').trigger('click');            
        }
        
        $('.date-picker').datetimepicker({
            format: "yyyy-mm-dd hh:ii:ss",
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            forceParse: 0,
            minView: 2 // No time
                    // showMeridian: 0
        });
        
        $('#btnCekBungaTambahan').click(function(){
            var btn = $(this).html();
            $(this).attr({"disabled":true}).html("Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID": $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR": "cekBungaTambahan",
                "command": "<%= Command.NONE %>"
            };
            onDone = function (data) {
                if (data.RETURN_ERROR_CODE == "1") {
                    if (confirm("Dikenakan bunga tambahan.\nGenerate bunga tambahan ?")) {
                        generateBungaTambahan();
                    }
                } else {
                    alert("Tidak dikenakan bunga tambahan");
                }
            };
            onSuccess = function (data) {
                $('#btnCekBungaTambahan').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        });
        
        $('#btnPenutupanKredit').click(function(){
            var btn = $(this).html();
            if (confirm("Yakin akan menutup kredit ini ?")) {
                $(this).attr({"disabled":true}).html("Tunggu...");
            } else {
                return false;
            }
            var dataSend = {
                "FRM_FIELD_OID"             : $('#oid-kredit').val(),
                "SEND_OID_TELLER_SHIFT"     : "<%=tellerShiftId%>",
                "FRM_FIELD_DATA_FOR"        : "cekPenutupanKredit",
                "TGL_TRANSAKSI"             : $('#tglTransaksi').val(),
                "command"                   : "<%= Command.SAVE %>"
            };
            onDone = function (data) {
                alert(data.RETURN_MESSAGE);
                if (data.RETURN_ERROR_CODE == "0") {
                    window.location = "../transaksikredit/form_pembayaran_kredit.jsp";
                }
            };
            onSuccess = function (data) {
                $('#btnPenutupanKredit').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        });
        
        function generateBungaTambahan() {
            var btn = $('#btnCekBungaTambahan').html();
            $('#btnCekBungaTambahan').attr({"disabled":true}).html("Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "generateBungaTambahan",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                alert(data.RETURN_MESSAGE);
            };
            onSuccess = function (data) {
                $('#btnCekBungaTambahan').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }
        
        $('#btnMulti').click(function(){
            var checked = 0;
            var multiIdJadwal = "";
            var jenis = "";
            $('#jadwalTableElement').find('.check_multi').each(function(){
                if ($(this).is(":checked")) {
                    checked++;
                    multiIdJadwal += (multiIdJadwal.length > 0) ? "," + $(this).val() : $(this).val();
                    jenis = $(this).data('jenis');
                }
            });
            if (checked == 0) {
                alert("Pilih jadwal !");
            } else {
                getJadwal(multiIdJadwal, jenis);
            }
        });
        
        function getJadwal(multiIdJadwal, jenis) {
            var lastRow = $('#jumlah_angsuran').val();
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "getSelectedSchedule",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>",
                "SEND_OID_MULTI"        : multiIdJadwal,
                "SEND_LAST_ROW"         : lastRow,
                "SEND_JENIS_ANGSURAN"   : jenis
            };
            onDone = function (data) {
                if (data.RETURN_ERROR != 0) {
                    alert(data.RETURN_MESSAGE);
                } else {
                    $('#angsuran' + lastRow).remove();
                    var newRow = data.RETURN_LAST_ROW;
                    console.log(newRow);
                    $('#jumlah_angsuran').val(newRow);
                    $('#LIST_ANGSURAN').append(data.FRM_FIELD_HTML);
                    console.log(data.FRM_FIELD_HTML);
                    var arrayRow = data.array_row;
                    $('#LIST_ANGSURAN').find('.money').each(function() {
                        var temp = $(this).data('total');
                        $(this).val(temp);
                        console.log(temp);
                        jMoney(this);
                    });
//                    arrayRow.forEach(myFunction);
                    hitungUang();
                    $('#modal-searchschedule').modal('hide');
                }
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
        }
        
        $('#bayarLunas').click(function(){
            var lastRow = $('#jumlah_angsuran').val();
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "getScheduleBayarLunas",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                if (data.RETURN_ERROR != 0) {
                    alert(data.RETURN_MESSAGE);
                } else {
                    $('#angsuran' + lastRow).remove();
                    var newRow = data.RETURN_LAST_ROW;
                    console.log(newRow);
                    $('#jumlah_angsuran').val(newRow);
                    $('#LIST_ANGSURAN').html(data.FRM_FIELD_HTML);
                    console.log(data.FRM_FIELD_HTML);
                    var arrayRow = data.array_row;
                    $('#LIST_ANGSURAN').find('.money').each(function() {
                        var temp = $(this).data('total');
                        $(this).val(temp);
                        console.log(temp);
                        jMoney(this);
                    });
//                    arrayRow.forEach(myFunction);
                    hitungUang();
                    $('#modal-searchschedule').modal('hide');
                }
                hitungUangOtomatis();
                $('body').on('keyup', '.inputPctDisc', function () {
                    var row = $(this).data('row');
                    var jumlah = $('#discPct' + row).val();
                    var sisaAngs = $('#sisaAngs'+row).val().replace(".","");
                    var discAmount = (+jumlah / 100.0) * +sisaAngs;
                    var jumlahBayar = sisaAngs - discAmount;
                    $('#discAmount'+row).val(discAmount.toFixed(2));
                    $('#jumlahBayar'+row).val(jumlahBayar.toFixed(2));
                    
                    let jsonData = $(this).data('rows');
                    let rowArray = jsonData.ROW
                    let sisa = +discAmount;
                    for(let i in rowArray){
                        console.log("==============================");
                        console.log('#inputAngsuran' + rowArray[i]);
                        let dataAngsuran = $('#inputAngsuran' + rowArray[i]);
                        let batasbayar = dataAngsuran.data('batasbayar');
                        console.log("Sisa = " + sisa);
                        console.log("Batas Bayar = " + batasbayar);
                        if (+batasbayar >= +sisa){
                            $('.valDiscAmount' + rowArray[i]).val(sisa);
                            $('.valDiscPct' + rowArray[i]).val(jumlah);
                            sisa = 0;
                        } else {
                            sisa = +discAmount - +batasbayar;
                            $('.valDiscAmount' + rowArray[i]).val(sisa);
                            $('.valDiscPct' + rowArray[i]).val(jumlah);
                        }
                    }
                    
                    
                    jMoney('#discAmount'+row);
                    jMoney('#jumlahBayar'+row);
                    hitungUangOtomatis();
                });
                $('body').on('keyup', '.inputAmountDisc', function () {
                    var row = $(this).data('row');
                    var jumlah = $('#discAmount' + row).val().replace(".","");
                    var sisaAngs = $('#sisaAngs'+row).val().replace(".","");
                    var discPct = (+jumlah / +sisaAngs) * 100.0;
                    var jumlahBayar = sisaAngs - jumlah;
                    $('#discPct'+row).val(discPct.toFixed(2));
                    $('#jumlahBayar'+row).val(jumlahBayar.toFixed(2));
                    
                    let jsonData = $(this).data('rows');
                    let rowArray = jsonData.ROW
                    let sisa = +jumlah;
                    for(let i in rowArray){
                        console.log("==============================");
                        console.log('#inputAngsuran' + rowArray[i]);
                        let dataAngsuran = $('#inputAngsuran' + rowArray[i]);
                        let batasbayar = dataAngsuran.data('batasbayar');
                        console.log("Sisa = " + sisa);
                        console.log("Batas Bayar = " + batasbayar);
                        if (+batasbayar >= +sisa){
                            $('.valDiscAmount' + rowArray[i]).val(sisa);
                            $('.valDiscPct' + rowArray[i]).val(discPct);
                            sisa = 0;
                        } else {
                            sisa = +jumlah - +batasbayar;
                            $('.valDiscAmount' + rowArray[i]).val(sisa);
                            $('.valDiscPct' + rowArray[i]).val(discPct);
                        }
                    }
                    
                    jMoney('#discPct'+row);
                    jMoney('#jumlahBayar'+row);
                    hitungUangOtomatis();
                });
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
        });
        
        function myFunction(value) {
            console.log("myFunction = " + value);
            jMoney('.jumlahAngsuran' + value);
            jMoney('#sisaAngsuran' + value);
            jMoney('#inputAngsuran' + value);
        }
        
        $('#btn_bayar').click(function(){
            $('#confirmationPay').val(0);
            $('#FORM_PEMBAYARAN').submit();
        });
        
        $('#btnConfirmPay').click(function(){
            $('#confirmationPay').val(1);
            $('#modal-confirm').modal('hide');
            $('#FORM_PEMBAYARAN').submit();
        });
        
        $('#checkAll').change(function() {
            if(this.checked) {
                $('.check_multi').each(function() {
                    this.checked = true;                        
                });
            } else {
                $('.check_multi').each(function() {
                    this.checked = false;                       
                });
            }
        });
        
        $('#btnNewSchedule').click(function() {
            getFormNewSchedule();
            modalSetting("#modal-generateSchedule", "static", false, false);
            $('#modal-generateSchedule').modal('show');
        });
        
        function getFormNewSchedule() {
            var lastRow = $('#jumlah_angsuran').val();
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "getFormNewSchedule",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                $('.date-picker').datetimepicker({
                    format: "yyyy-mm-dd",
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "#formNewSchedule", false);
        }
        
        $('#btnSaveSchedule').click(function() {
            var btn = $(this).html();
            $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
            var dataSend = $('#formNewSchedule').serialize();
            onDone = function (data) {
                alert(data.RETURN_MESSAGE);
                $('#modal-generateSchedule').modal('hide');
            };
            onSuccess = function (data) {
                $('#btnSaveSchedule').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        });
        
        $('#angsuranDP').click(function() {
            var btn = $(this).html();
            //$(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "getAngsuranDP",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                if (data.RETURN_ERROR != 0) {
                    alert(data.RETURN_MESSAGE);
                } else {
                    $('#btn_clear_angsuran').trigger('click');
                    $('#LIST_ANGSURAN').html(data.FRM_FIELD_HTML);
                    $('#LIST_ANGSURAN').find('.money').each(function() {
                        jMoney(this);
    });
                    $('#inputSetoran0').val(data.RETURN_JUMLAH_UANG)
                    jMoney('#inputSetoran0');
                    hitungUang();
                }
            };
            onSuccess = function (data) {
                $('#angsuranDP').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
        });
        $('#angsuranPertama').click(function() {
            var btn = $(this).html();
            //$(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID"         : $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR"    : "getAngsuranPertama",
                "command"               : "<%= Command.NONE %>",
                "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
            };
            onDone = function (data) {
                if (data.RETURN_ERROR != 0) {
                    alert(data.RETURN_MESSAGE);
                } else {
                    $('#btn_clear_angsuran').trigger('click');
                    $('#LIST_ANGSURAN').html(data.FRM_FIELD_HTML);
                    $('#LIST_ANGSURAN').find('.money').each(function() {
                        jMoney(this);
                });
                    $('#inputSetoran0').val(data.RETURN_JUMLAH_UANG)
                    jMoney('#inputSetoran0');
                    hitungUang();
                    $('#btn_printTransaksi').show();
                }
            };
            onSuccess = function (data) {
                $('#angsuranDP').removeAttr('disabled').html(btn);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
        });
        
        $('body').on('keyup', '.inputJumlahBayar', function(){
            let bayaran = $(this).val();
            let jsonData = $(this).data('rows');
            let bayarMax = $(this).data('batasbayar');
            
            let rowArray = jsonData.ROW
            let tableBody = $('#LIST_ANGSURAN');
            let jumlahBayar = bayaran.replace(/([.])/g, "");
            let sisa = parseFloat(jumlahBayar);
            
            if(parseFloat(jumlahBayar) >= bayarMax){
                sisa = bayarMax;
                $(this).val(bayarMax);
                jMoney(this);
            }
            
            for(let i in rowArray){
                console.log("==============================");
                console.log('#inputAngsuran' + rowArray[i]);
                let dataAngsuran = $('#inputAngsuran' + rowArray[i]);
                let batasbayar = dataAngsuran.data('batasbayar');
                let hitungBayar = sisa - batasbayar;
                console.log("Sisa = " + sisa);
                console.log("Batas Bayar = " + batasbayar);
                console.log("Hitung Bayar = " + hitungBayar);
                let hasil = (sisa >= batasbayar ? batasbayar : (sisa > 0 ? sisa : 0));
                console.log("-----------------------------");
                console.log("Hasil = " + hasil);
                dataAngsuran.val(hasil);
                $('.valJumlahDibayar' + rowArray[i]).val(hasil);
                sisa = hitungBayar;
                console.log("==============================");
            }
            
            hitungUang();
            
        });
        
        $('body').on("click", "#btn_printTransaksi", function () {
            var buttonHtml = $(this).html();
            $(this).attr({"disabled": "true"}).html("Tunggu...");
            var dataSend = {
                "FRM_FIELD_OID": $('#oid-kredit').val(),
                "FRM_FIELD_DATA_FOR": "getPrintOutAngsuranPertama",
                "FRM_FIELD_USER_LOCATION" : "<%= userLocationId %>",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                $('#btn_printTransaksi').removeAttr('disabled').html(buttonHtml);
                $('#printOut').html(data.FRM_FIELD_HTML);
                $('#printOut').find(".money").each(function () {
                    jMoney(this);
                });
                $('#compName').html("<%=compName%>");
                $('#compAddr').html("<%=compAddr%>");
                $('#compPhone').html("<%=compPhone%>");
                $('#adminCetak').html("<%=userFullName%>");
                window.print();
            };
            onSuccess = function (data) {
            };
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
        });
                                
        $('body').on('change', '#POSITION_ID', function(){
            runKolektorDataTable();
        });
        $('body').on('change', '#LOKASI_KOLEKTOR', function(){
            runKolektorDataTable();
        });
        
        let modalAssignKolektor = $('#modal-assign-kolektor');
        $('body').on('click', '#ganti-kolektor-btn', function(){
            let oid = $('#oid-kredit').val();
            if (oid === "" || oid === "0") {
                alert("Pilih data kredit terlebih dahulu !");
                $('#btn-searchkredit').trigger('click');
                return false;
            }
            
            let noKredit = $('#NOMOR_KREDIT').val();
            let nasabah = $('#NAMA_NASABAH').val();
            let noNasabah = $('#NOMOR_NASABAH').val();
            let kolektor = $('#KOLEKTOR').val();
            let judulModal = "<span class='text-bold'>Assign Kolektor</span> |"
                            + " No Kredit : " + noKredit + "&nbsp;&nbsp;&nbsp;"
                            + " Nama <%= namaNasabah%> : " + nasabah + " &nbsp;(" + noNasabah + ")";
            
            modalAssignKolektor.modal('show');
            
            modalAssignKolektor.find(".modal-body #sisi-kiri").addClass('col-sm-4');
            modalAssignKolektor.find(".modal-body #sisi-kanan").addClass('col-sm-8');
            
            modalAssignKolektor.find(".modal-header .modal-title").html(judulModal);
            modalAssignKolektor.find(".modal-body #PREV_KOLEKTOR").val(kolektor);
            
            modalAssignKolektor.find(".modal-body #summary-kolektor").css('display', '');
            modalAssignKolektor.find(".modal-footer #footer-bagian-bawah").css('display', '');
            
            modalAssignKolektor.find(".modal-footer #PINJAMAN_ID_MODAL").val(oid);
            modalAssignKolektor.find(".modal-body #SEARCH_TYPE").val('0');

            modalAssignKolektor.find(".modal-footer #pilih-kolektor-btn").addClass('simpan-kolektor-baru');
            runKolektorDataTable();
        });
        
        $('body').on('click', '#btn-searchkolektor', function(){
            let judulModal = "<span class='text-bold'>Pilih Kolektor</span>";
            
            modalAssignKolektor.modal('show');
            
            modalAssignKolektor.find(".modal-body #sisi-kiri").addClass('col-sm-4');
            modalAssignKolektor.find(".modal-body #sisi-kanan").addClass('col-sm-8');
            
            modalAssignKolektor.find(".modal-header .modal-title").html(judulModal);
            modalAssignKolektor.find(".modal-body #summary-kolektor").css('display', 'none');
            modalAssignKolektor.find(".modal-footer #footer-bagian-bawah").css('display', 'none');
            
            modalAssignKolektor.find(".modal-body #SEARCH_TYPE").val('1');
            
            runKolektorDataTable();
        });
                
        $('body').on('click', '.pilih-kolektor', function(){
            let name = $(this).data('name');
            let oid = $(this).val();

            modalAssignKolektor.find(".modal-body #NEW_KOLEKTOR").val(name);
            modalAssignKolektor.find(".modal-footer #NEW_KOLEKTOR_ID").val(oid);

        });
        
        $('body').on('click', '.select-kolektor', function(){
            let name = $(this).data('name');
            let oid = $(this).val();

            $('#oid-kolektor').val(oid);
            $('#KOLEKTOR_NAME').val(name);

            modalAssignKolektor.modal('hide');
        });
        
        $('body').on('click', '.simpan-kolektor-baru', function(){
            let btnHtml = $(this).html();
            $(this).html("Tunggu...").attr({"disabled": "true"});
            let command = "<%= Command.SAVE %>";
            let pinjaman = $('#PINJAMAN_ID_MODAL').val();
            let kolektor = $('#NEW_KOLEKTOR_ID').val();
            let approot = "<%= approot%>";

            let dataSend = {
                "command": command,
                "FRM_FIELD_DATA_FOR": "updateKolektorBaru",
                "PINJAMAN_ID": pinjaman,
                "NEW_KOLEKTOR_ID": kolektor
            };

            onDone = function(data){
                let code = data.RETURN_ERROR_CODE;
                let type = "";
                if(code == 0){
                    type = "success";
                } else {
                    type = "error";
                }
                fireSwal('center', type, data.RETURN_MESSAGE);
                $('#simpan-kolektor-baru').removeAttr('disabled').html(btnHtml);
                let kolektor = $('#KOLEKTOR').val(data.FRM_RETURN_KOLEKTOR_NAME);
                modalAssignKolektor.modal('hide');
            };
            onSuccess = function (data) {};
            
            getDataFunctionv2(onDone, onSuccess, approot, command, dataSend, "AjaxAnggota", null, false);

        });
        
    });
    </script>
  </head>
  <body style="background-color: #eaf3df;">
    <div class="main-page">
        <section class="content-header">
          <h1>
            Pembayaran Kredit
            <small></small>
          </h1>
          <ol class="breadcrumb">
            <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
            <li>Transaksi</li>
            <li class="active">Kredit</li>
          </ol>
        </section>

        <section class="content">

          <% if (iCommand == Command.NONE) {%>

          <div class="box box-success">
            <div class="box-header with-border" style="border-color: lightgray">
              <h3 class="box-title">Form Pembayaran</h3>
            </div>

            <p></p>

            <form id="FORM_PEMBAYARAN" class="form-horizontal">
              <input type="hidden" class="hidden" name="userOID" value="<%=userOID%>">
              <input type="hidden" class="hidden" id="confirmationPay" name="CONFIRMATION_PAY" value="0">
              <div class="box-body">
                <div class="">
                  <div class="col-sm-7">
                    <div class="form-group">
                      <label class=" col-sm-3">Tanggal Transaksi</label>
                      <div class="col-sm-8">
                          <input type="text" id="tglTransaksi" class="form-control input-sm date-picker" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") %>" name="TGL_TRANSAKSI_PEMBAYARAN">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-3">Kolektor</label>
                      <div class="col-sm-8">
                           <% if (empKolektor.getOID() == 0){ %>
                            <div class="input-group">
                              <input type="text" autocomplete="off" required="" class="form-control input-sm" value="" name="" id="KOLEKTOR_NAME" <%=(empKolektor.getOID()> 0 ? "value='"+empKolektor.getFullName()+"' readonly='readonly'" : "value=''")%>>
                              <span class="input-group-addon btn btn-primary" id="btn-searchkolektor">
                                <i class="fa fa-search"></i>
                              </span>
                            </div>
                            <% } else { %>
                            <input type="text" autocomplete="off" required="" class="form-control input-sm" value="<%=empKolektor.getFullName()%>" readonly="readonly" name="" id="KOLEKTOR_NAME">
                            <% } %>
                          <input type="hidden" id="oid-kolektor" <%=(empKolektor.getOID()> 0 ? "value='"+empKolektor.getOID()+"' readonly='readonly'" : "value=''")%> name="KOLEKTOR_ID">
                      </div>
                    </div>
                      
                    <div class="form-group">
                      <label class=" col-sm-3">Nomor Kredit</label>
                      <div class="col-sm-8">
                        <div class="input-group">
                          <input type="text" autocomplete="off" required="" class="form-control input-sm" value="" name="" id="NOMOR_KREDIT">
                          <span class="input-group-addon btn btn-primary" id="btn-searchkredit">
                            <i class="fa fa-search"></i>
                          </span>
                        </div>
                        <input type="hidden" id="oid-kredit" value="" name="PINJAMAN_ID">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-3">Jenis Kredit</label>
                      <div class="col-sm-8">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="JENIS_KREDIT">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-3"><%=namaNasabah%></label>
                      <div class="col-sm-3">
                        <input type="hidden" id="ID_NASABAH">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="NOMOR_NASABAH">
                      </div>
                      <div class="col-sm-5">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="NAMA_NASABAH">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-3">Alamat</label>
                      <div class="col-sm-8">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="ALAMAT_NASABAH">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-3">Jumlah Kredit</label>
                      <div class="col-sm-4">
                        <div class="input-group">
                          <span class="input-group-addon">Rp</span>
                          <input type="text" readonly="" data-cast-class="valJumlahPinjaman" class="form-control input-sm money" value="" name="" id="JUMLAH_PINJAMAN">
                          <input type="hidden" class="valJumlahPinjaman" value="" name="" id="VAL_JUMLAH_PINJAMAN">
                        </div>                                        
                      </div>
                      <div class="col-sm-4">
                        <div class="input-group">
                          <input type="text" readonly="" class="form-control input-sm" value="" name="" id="JANGKA_WAKTU">
                          <span class="input-group-addon">Kali angsuran</span>
                        </div>                                        
                      </div>
                    </div>    
                    <div class="form-group">
                      <label class=" col-sm-3">Suku Bunga</label>
                      <div class="col-sm-4">
                        <div class="input-group">
                          <input type="text" readonly="" data-cast-class="valSukuBunga" class="form-control input-sm money" value="" name="" id="SUKU_BUNGA">
                          <input type="hidden" class="valSukuBunga" value="" id="VAL_SUKU_BUNGA">
                          <span class="input-group-addon">% / Tahun</span>
                        </div>
                      </div>
                      <div class="col-sm-4">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="JENIS_BUNGA">
                      </div>
                    </div>
                  </div>

                  <div class="col-sm-5">
                    <div class="form-group">
                      <label class=" col-sm-5">Tanggal Pengajuan</label>
                      <div class="col-sm-6">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="TGL_PENGAJUAN">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-5">Tanggal Realisasi</label>
                      <div class="col-sm-6">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="TGL_REALISASI">
                      </div>
                    </div>

                    <div class="form-group">
                      <label class=" col-sm-5">Tanggal Jatuh Tempo</label>
                      <div class="col-sm-6">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="TGL_JATUH_TEMPO">
                      </div>
                    </div>
                    
                    <div class="form-group">
                      <label class=" col-sm-5">Analis Kredit</label>
                      <div class="col-sm-6">
                        <input type="text" readonly="" class="form-control input-sm" value="" name="" id="ANALIS">
                      </div>
                    </div>
                    <div class="form-group">
                      <label class=" col-sm-5">Kolektor</label>
                      <div class="col-sm-6">
                          <div class="input-group">
                            <input type="text" readonly="" class="form-control input-sm" value="" name="" id="KOLEKTOR">
                            <span id="ganti-kolektor-btn" class="input-group-addon" style="cursor: pointer;">
                                <i class="fa fa-search"></i>
                            </span>
                          </div>
                      </div>
                    </div>

                    <hr style="border-color: lightgray">

                    <div class="form-group">
                      <div class="col-sm-12">
                        <table style="font-size: 14px">
                          <tr>
                            <td style="vertical-align: text-top; width: 120px">Total Angsuran Pokok</td>
                            <td style="vertical-align: text-top; padding: 0px 10px">:</td>
                            <td>Rp <span id="totalPokok" class="money"></span><br>Sisa <span id="sisaPokok" class="money"></span></td>
                          </tr>
                          <tr>
                            <td style="vertical-align: text-top">Total Angsuran Bunga</td>
                            <td style="vertical-align: text-top; padding: 0px 10px">:</td>
                            <td>Rp <span id="totalBunga" class="money"></span><br>Sisa <span id="sisaBunga" class="money"></span></td>
                          </tr>
                          <tr>
                            <td style="vertical-align: text-top">Total Nilai Denda</td>
                            <td style="vertical-align: text-top; padding: 0px 10px">:</td>
                            <td>Rp <span id="totalDenda" class="money"></span><br>Sisa <span id="sisaDenda" class="money"></span></td>
                          </tr>
                        </table>
                        <table style="font-size: 14px">
                          <tr>
                        <%if(useRaditya == 1){} else{%>
                              <td style="padding-right: 5px; padding-top: 10px"><button type="button" id="btnCekBungaTambahan" class="hidden btn btn-xs btn-default">Cek Bunga Tambahan</button></td>
                        <%}%>
                              <td style="padding-right: 5px; padding-top: 10px"><button type="button" id="btnNewSchedule" class="hidden btn btn-xs btn-default">Jadwal Baru</button></td>
                              <td style="padding-right: 5px; padding-top: 10px"><button type="button" id="btnPenutupanKredit" class="hidden btn btn-xs btn-default">Penutupan Kredit</button></td>
                          </tr>
                          </table>
                      </div>
                    </div>

                    <div class="comboTipeKartu"></div>
                    <div class="jenisTabungan"></div>
                  </div>
                </div>

                <div class="col-sm-12">
                  <hr style="border-color: lightgray">
                  <div class="">
                    <label class="">Jenis Pembayaran :</label>
                  </div>

                  <input type="hidden" value="0" id="jumlah_setoran">

                  <table style="width: 80%" class="table table-bordered">
                    <thead>
                      <tr>
                        <th style="width: 30%">Cara Bayar</th>
                        <th style="width: 40%">Keterangan</th>
                        <th style="width: 30%">Jumlah Uang</th>
                        <th style="width: 1%"><i class="fa fa-pencil"></i></th>
                      </tr>
                    </thead>
                    <tbody id="LIST_SETORAN">
                      <tr id="setoran0">
                        <td>
                          <select class="form-control input-sm selectPayment" id="selectPayment0" data-row="0" name="FORM_PAYMENT_TYPE">
                            <%
                              for(Map.Entry<Integer,String> entry : AngsuranPayment.TIPE_PAYMENT.entrySet()) {
                                String selected = entry.getKey() == AngsuranPayment.TIPE_PAYMENT_CASH ? "selected" : "";
                                out.print("<option "+selected+" value='"+entry.getKey()+"'>"+entry.getValue()+"</option>");
                              }
                           %>
                          </select>                      
                          <input type="hidden" class="valPaymentType" id="valPaymentType0" name="FORM_PAYMENT_ID" value="<%=idPayment%>">                                            
                        </td>
                        <td>
                          <input type="text" readonly="" id="keterangan0" class="form-control input-sm keterangan" data-row="0">
                          <!--input tambahan untuk payment tabungan-->
                          <input type="hidden" id="oidSimpanan0" name="FORM_OID_SIMPANAN">
                          <input type="hidden" id="jumlahPenarikan0" name="FORM_JUMLAH_PENARIKAN_TABUNGAN">
                          <!--input tambahan untuk payment credit/debit card-->
                          <input type="hidden" id="cardNumber0" name="FORM_CARD_NUMBER">
                          <input type="hidden" id="bankName0" name="FORM_BANK_NAME">
                          <input type="hidden" id="validate0" name="FORM_VALIDATE">
                          <!--input tambahan untuk payment credit card-->
                          <input type="hidden" id="cardName0" name="FORM_CARD_NAME">
                        </td>
                        <td>
                          <input type="text" autocomplete="off" required="" data-cast-class="valJumlahSetoran0" class="form-control input-sm money inputSetoran" id="inputSetoran0" data-row="0">
                          <input type="hidden" class="valJumlahSetoran0 valSetoran" name="FORM_JUMLAH_SETORAN" value="">
                        </td>
                        <td><button style="color: #dd4b39;" type="button" data-row="0" class="btn btn-sm btn-default btn_remove_setoran"><i class="fa fa-minus"></i></button></td>
                      </tr>                                    
                    </tbody>
                    <tfoot class="m-footer" style="display:none;">
                      <tr>   
                        <td colspan="2">
                          <div id="showBtnDP" style="display: none">
                            <% if(useRaditya == 1){ %>
                            <button type="button" style="text-decoration-line: none; margin-bottom: 5px" class="btn btn-sm btn-success" id="angsuranPertama">Angsuran Pertama</button>
                            <br>
                            <%}else{%>
                            <button type="button" style="text-decoration-line: none" class="btn btn-sm btn-success" id="angsuranDP">Angsuran DP</button>
                            <br>
                            <%}%>
                          </div>
                          <button type="button" style="text-decoration-line: none; margin-bottom: 5px" class="btn btn-sm btn-success" id="byPriority">Bayar sesuai prioritas (Denda > DP > Angsuran)</button>
                          <br>
                          <button type="button" style="text-decoration-line: none; margin-bottom: 5px" class="btn btn-sm btn-success" id="bayarLunas">Bayar Lunas</button>
                          <br>
                          <% if(useRaditya == 0){ %>
                          <button type="button" data-disable="false" data-link="ajax/kredit-angsuran-bunga-list.jsp" style="text-decoration-line: none" class="btn btn-sm btn-link auto-list">Bayar seluruh bunga (Sisa)</button>
                          <br>
                          <button type="button" data-disable="true" data-link="ajax/kredit-angsuran-pelunasan-list.jsp?macet=0" style="text-decoration-line: none; display: none;" class="btn btn-sm btn-link auto-list pelunasan-awal">Pelunasan Lebih Awal</button>
                          <br>
                          <button type="button" data-disable="true" data-link="ajax/kredit-angsuran-pelunasan-list.jsp?macet=1" style="text-decoration-line: none; display:none;" class="btn btn-sm btn-link auto-list pelunasan-macet">Pelunasan Macet</button>
                          <% } %>
                          <script>
                            jQuery(() => {
                                $("body .auto-list").click(function() {
                                    var uri = $(this).data("link");
                                    var disable = $(this).data("disable");
                                    var code = $("body #NOMOR_KREDIT").val();
                                    if (!code) {
                                        alert("Pilih data kredit terlebih dahulu !");
                                        $('#btn-searchkredit').trigger('click');
                                    } else {
                                        basicAjax(baseUrl(uri), (r) => {
                                            var res = JSON.parse(r);
                                            if (res.list.length < 1) {
                                                alert("Data angsuran tidak ditemukan.\nMohon periksa nomor kredit.");
                                            } else {
                                                $("body #LIST_ANGSURAN, body #LIST_SETORAN").empty();
                                                var p = $(elementPayment());
                                                $("body #jumlahUang").html(res.total);
                                                $(p).find(".money.inputSetoran").val(res.total);
                                                jMoney($(p).find(".money.inputSetoran"));
                                                jMoney($("body #jumlahUang"));
                                                $("body #LIST_SETORAN").html(p);
                                                var i = 0;
                                                for (; i < res.list.length; i++) {
                                                    var penalty = (res.list[i].penalty);
                                                    var s = $(elementAngsuran(i));
                                                    var js = $(s).find(".select-jenis-angsuran");
                                                    var btn = $(s).find(".btn_remove_angsuran");
                                                    $(js).val(res.list[i].jenisAngsuran);
                                                    $(s).find(".jadwalAngsuran").val(res.list[i].jadwalAngsuranId);
                                                    $(s).find(".jadwal").val(res.list[i].date);
                                                    $(s).find(".jumlahAngsuran").val(res.list[i].total);
                                                    $(s).find(".sisaAngsuran").val(res.list[i].remaining);
                                                    $(s).find(".inputAngsuran").val(res.list[i].remaining);
                                                    jMoney($(s).find(".jumlahAngsuran"));
                                                    jMoney($(s).find(".sisaAngsuran"));
                                                    jMoney($(s).find(".inputAngsuran"));
                                                    if(disable) {
                                                        $(s).find(".btn-searchschedule").remove();
                                                        $(btn).removeClass("btn_remove_angsuran");
                                                        $(btn).attr("disabled", "");
                                                        $(btn).css("color", "grey");
                                                        $(s).find("select").hide();
                                                        $(s).find("input").attr("readonly", "");
                                                        $(js).hide();
                                                        $(js).closest("td").append('<input readonly="" value="' + $(js).children("option:selected").text() + '" class="form-control input-sm txt-pelunasan">');
                                                    }
                                                    if(penalty) {
                                                        var macet = (res.list[i].macet=="true");
                                                        $(s).find(".txt-pelunasan").val("Penalti "+(macet?"Macet":"Pelunasan"))
                                                        $(s).find(".inputAngsuran").removeAttr("readonly");
                                                        $(s).find(".inputAngsuran").keyup(function(){
                                                            $(s).find(".jumlahAngsuran").val($(this).val());
                                                            $(s).find(".sisaAngsuran").val($(this).val());
                                                            $(s).find(".valSisaAngsuran").val($(this).siblings(".valAngsuran").val());
                                                        });
                                                    }
                                                    $("body #LIST_ANGSURAN").append(s);
                                                }
                                                $("body #jumlah_angsuran").val(i);
                                                $("body #sisaUang").html("0");
                                                $('body #totalBayar').html(res.total);
                                                jMoney('body #totalBayar');
                                                jMoney('body #sisaUang');
                                            };
                                        }, {"kredit": code});
                                    };
                                });
                            });
                            </script>
                        </td>
                        <td class="text-right">
                          <label class="control-label">Total : Rp <b id="jumlahUang" data-cast-class="valTotal" class="money"></b></label>
                          <input type="hidden" class="valTotal">
                        </td>
                        <td><button style="color: #00a65a;" type="button" id="btn_add_setoran" class="btn btn-sm btn-default"><i class="fa fa-plus"></i></button></td>
                      </tr>
                    </tfoot>
                  </table>                            
                </div>                                        
                  <div class="row col-md-12" id="biayaLain">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <div class="col-sm-6">
                                <div id="LIST_BIAYA"></div>
                            </div>
                        </div>
                    </div>
                  </div>
                <div class="col-sm-12">
                  <div class="">
                    <label class="">Jadwal Angsuran Dibayar :</label>
                  </div>

                  <input type="hidden" value="0" id="jumlah_angsuran">

                  <table style="width: 100%" class="table table-bordered">
                    <thead>
                      <tr>
                        <th style="width: 150px">Jenis Angsuran</th>
                        <th>Jatuh Tempo</th>
                        <th>Jumlah Angsuran</th>
                        <th>Sisa Angsuran</th>
                        <th>Diskon %</th>
                        <th>Diskon Rp.</th>
                        <th>Jumlah Dibayar</th>
                        <th style="width: 1%"><i class="fa fa-pencil"></i></th>
                      </tr>
                    </thead>
                    <tbody id="LIST_ANGSURAN">
                      <tr id="angsuran0">
                        <td class="text-center">
                          <select class="form-control input-sm jenisAngsuran0" data-row="0" name="FRM_FIELD_JENIS_ANGSURAN">                                                
                            <% 
                              if(useRaditya == 1){
                              for(int ta=0; ta<(JadwalAngsuran.TIPE_ANGSURAN_RADITYA_VALUE.length); ta++) { out.print("<option value='"+JadwalAngsuran.TIPE_ANGSURAN_RADITYA_VALUE[ta]+"'>"+JadwalAngsuran.TIPE_ANGSURAN_RADITYA_TITLE[ta]+"</option>"); } 
                              }else{
                              for(int ta=0; ta<(JadwalAngsuran.TIPE_ANGSURAN_VALUE.length); ta++) { out.print("<option value='"+JadwalAngsuran.TIPE_ANGSURAN_VALUE[ta]+"'>"+JadwalAngsuran.TIPE_ANGSURAN_TITLE[ta]+"</option>"); } 
                              }
                            %>
                          </select>
                        </td>
                        <td class="text-center">
                          <div class="input-group">
                            <input type="text" required="" readonly="" class="form-control input-sm jadwal jadwalAngsuran0">
                            <input type="hidden" class="jadwalAngsuran idJadwal0" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JADWAL_ANGSURAN_ID]%>">
                            <span class="input-group-addon btn btn-primary btn-searchschedule" data-row="0"><i class="fa fa-search"></i></span>
                          </div>
                        </td>
                        <td class="text-center">
                          <input type="text" readonly="" data-cast-class="valTotalAngsuran" class="form-control input-sm jumlahAngsuran jumlahAngsuran0" data-row="0">
                          <input type="hidden" class="valTotalAngsuran" id="valTotalAngsuran0">
                        </td>
                        <td class="text-center">
                          <input type="text" readonly="" data-cast-class="valSisaAngsuran" class="form-control input-sm sisaAngsuran" id="sisaAngsuran0" data-row="0">
                          <input type="hidden" class="valSisaAngsuran" id="valSisaAngsuran0" name="FORM_SISA_ANGSURAN">
                        </td>
                        <td class="text-center">
                          <input type="text" autocomplete="off" required="" data-cast-class="valDiscPct0" class="form-control input-sm money inputDicPct" id="inputDicPct0" data-row="0">
                          <input type="hidden" class="valDiscPct0" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_PCT]%>">
                        </td>
                        <td class="text-center">
                          <input type="text" autocomplete="off" required="" data-cast-class="valDiscAmount0" class="form-control input-sm money inputDicAmount" id="inputDicAmount0" data-row="0">
                          <input type="hidden" class="valDiscAmount0" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_DISC_AMOUNT]%>">
                        </td>
                        <td class="text-center">
                          <input type="text" autocomplete="off" required="" data-cast-class="valJumlahDibayar0" class="form-control input-sm money inputAngsuran" id="inputAngsuran0" data-row="0">
                          <input type="hidden" class="valJumlahDibayar0 valAngsuran" value="" name="<%=FrmAngsuran.fieldNames[FrmAngsuran.FRM_FIELD_JUMLAH_ANGSURAN]%>">
                        </td>
                        <td class="text-center">
                          <button style="color: #dd4b39;" type="button" data-row="0" class="btn btn-sm btn-default btn_remove_angsuran"><i class="fa fa-minus"></i></button>
                        </td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <td colspan="7" class="text-right">
                          <div><b>Total Bayar : Rp </b><label id="totalBayar" class="money"></label></div>
                          <div><b>Selisih Uang : Rp </b><label id="sisaUang" class="money"></label></div>
                          <div><label style="color: red" id="pesan"></label></div>
                        </td>
                        <td class="text-center">
                          <button style="color: #00a65a;" type="button" id="btn_add_angsuran" data-row="0" class="btn btn-sm btn-default"><i class="fa fa-plus"></i></button>
                          <div style="width:100%; height:10px;"></div>
                          <button type="button" id="btn_clear_angsuran" data-row="0" title="Clear" style="" class="btn btn-sm btn-warning"><b style="font-size:15px;">C</b></button>
                          <script>
                            jQuery(() => {
                                $("body #btn_clear_angsuran").click(() => {
                                    $("body #LIST_ANGSURAN, body #LIST_SETORAN").empty();
                                    var p = $(elementPayment());
                                    var s = $(elementAngsuran());
                                    $("body #jumlahUang").html(0);
                                    $("body #totalBayar").html(0);
                                    $("body #sisaUang").html(0);
                                    jMoney($(p).find(".money.inputSetoran"));
                                    jMoney($("body #jumlahUang"));
                                    jMoney($("body #totalBayar"));
                                    jMoney($("body #sisaUang"));
                                    jMoney($(s).find(".jumlahAngsuran"));
                                    jMoney($(s).find(".sisaAngsuran"));
                                    jMoney($(s).find(".inputAngsuran"));
                                    $("body #LIST_ANGSURAN").append(s);
                                    $("body #LIST_SETORAN").html(p);
                                    $("body #jumlah_angsuran").val(0);
                                    $("body #jumlah_setoran").val(0);
                                    $("body #pesan").html("");
                                });
                            });
                          </script>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
                        
                <div class="col-sm-12">
                    <div class="form-group">
                        <div class="col-sm-6">
                            <label>Keterangan :</label>
                            <textarea style="resize: none" placeholder="..." class="form-control" name="KETERANGAN_TRANSAKSI_PEMBAYARAN"></textarea>
                        </div>
                    </div>
                </div>
              </div>

              <div class="box-footer" style="border-color: lightgray">
                <div class="col-sm-12">
                  <div style="width: 100%">
                    <div class="pull-right">
                        <button type="button" id="btn_printTransaksi" class="btn btn-sm btn-default"><i class="fa fa-print"></i> &nbsp; Cetak Bukti Transaksi</button>&nbsp; 
                        <button type="button" id="btn_bayar" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Bayar</button>
                    </div>
                  </div>
                </div>
              </div>
            </form>

          </div>

          <%}%>

        </section>
    </div>
    <!--------------------------------------------------------------------->

    <print-area>
      <div style="size: A4;" id="printOut">
           
      </div>
    </print-area>

    <!--------------------------------------------------------------------->

    <div id="modal-searchkredit" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">

          <div class="modal-header">
            <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Data Kredit</h4>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-md-12">

                <div id="pinjamanTableElement">
                    <table class="table" style="font-size: 14px">
                    <thead>
                      <tr>
                        <th class="aksi">No.</th>
                        <th>Nomor Kredit</th>
                        <th>Nama <%=namaNasabah%></th>
                        <th>Jenis Kredit</th>
                        <th>Jumlah Kredit</th>
                        <th>Lokasi</th>
                        <th>Tanggal Pengajuan</th>
                        <!--th>Sumber Dana</th-->
                        <th>Tanggal Realisasi</th>
                        <th>Status Barang</th>
                        <th class="aksi">Aksi</th>
                      </tr>
                    </thead>
                  </table>
                </div>

              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
          </div>

        </div>
      </div>
    </div>

    <div id="modal-searchschedule" class="modal fade" role="dialog">
      <div class="modal-dialog modal-lg">                
        <div class="modal-content">

          <div class="modal-header">
            <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Jadwal Angsuran Kredit</h4>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-md-12">

                <div id="jadwalTableElement">
                  <table class="table" style="font-size: 14px">
                    <thead>
                      <tr>
                        <th class="aksi">No.</th>
                        <th>Jatuh Tempo</th>
                        <th>Jenis Angsuran</th>
                        <th>Jumlah Angsuran</th>                                                
                        <th>Jumlah Dibayar</th>
                        <th>Frekuensi Bayar</th>
                        <th>Sisa Angsuran</th>
                        <th class="aksi"><input type="checkbox" id="checkAll"></th>
                      </tr>
                    </thead>
                  </table>
                </div>

              </div>
            </div>
          </div>

          <div class="modal-footer">
              <button type="button" class="btn btn-sm btn-primary" id="btnMulti" ><i class="fa fa-check"></i> &nbsp; Pilih</button>
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
          </div>

        </div>
      </div>
    </div>

    <div id="modal-searchtabungan" class="modal fade" role="dialog">
      <div class="modal-dialog">                
        <div class="modal-content">

          <div class="modal-header">
            <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Daftar Tabungan</h4>
          </div>

          <div class="modal-body">
            <div class="row">
              <div class="col-md-12">

                <div id="tabunganTableElement">
                  <table class="table table-bordered table-striped">
                    <thead>
                      <tr>
                        <th class="aksi">No.</th>
                        <th>Nomor Tabungan</th>
                        <th>Jenis Simpanan</th>
                        <th>Saldo Tabungan</th>
                        <th class="aksi">Aksi</th>
                      </tr>
                    </thead>
                    <tbody id="dataTabelTabungan"></tbody>
                  </table>
                </div>

              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
          </div>

        </div>
      </div>
    </div>

    <div id="modal-detailPayment" class="modal fade" role="dialog">
      <div class="modal-dialog">                
        <div class="modal-content">

          <div class="modal-header">
            <div class="col-sm-12">
              <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">Detail Payment</h4>
            </div>
          </div>

          <form id="form_detail" class="form-horizontal">

            <div class="modal-body">
              <div class="row">
                <div class="col-md-12">
                  <div class="col-md-12">

                    <input type="hidden" id="detail_row">

                    <div id="form_body_detail">

                    </div>

                  </div>
                </div>
              </div>
            </div>

            <div class="modal-footer">
              <div class="col-sm-12">
                <button type="submit" id="btn_infokartu" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Selesai</button>
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
              </div>                            
            </div>

          </form>

        </div>
      </div>
    </div>
                            
    <div id="modal-confirm" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Konfirmasi</h4>
                </div>

                <div class="modal-body">
                        <div id="appendBody"></div>
                </div>

                <div class="modal-footer">
                        <button type="button" id="btnConfirmPay" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Lanjutkan</button>
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                </div>

            </div>
        </div>
    </div>
                        
    
    <div id="modal-generateSchedule" class="modal fade" role="dialog">
        <div class="modal-dialog">                
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Jadwal Baru</h4>
                </div>

                <div class="modal-body">
                    <form id="formNewSchedule" class="form-horizontal">

                    </form>
                </div>

                <div class="modal-footer">
                    <button type="button" id="btnSaveSchedule" class="btn btn-sm btn-success"><i class="fa fa-save"></i> &nbsp; Simpan</button>
                    <button type="button" id="btn_close" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                </div>

            </div>
        </div>
    </div>

    <div id="modal-assign-kolektor" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg">                
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">
                            
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div id="sisi-kiri">
                            <div class="row">
                                <form id="KOLEKTOR_SEARCH_PARAM">
                                    <input type="hidden" id="SEARCH_TYPE" name="SEARCH_TYPE" value="">
                                    <div class="col-sm-12">
                                        <div class="box box-success">
                                            <div class="box-header">
                                                <h4 class="box-title">Form Pencarian</h4>
                                            </div>
                                            <div class="box-body">
                                                <div class="form-group">
                                                    <label for="POSITION_ID">Position</label>
                                                    <select class="form-control" name="POSITION_ID" id="POSITION_ID">
                                                        <%= optPosition%>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="LOKASI_KOLEKTOR">Lokasi</label>
                                                    <select class="form-control" name="LOKASI_KOLEKTOR" id="LOKASI_KOLEKTOR">
                                                        <%= optLocation%>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div id="summary-kolektor" class="row">
                                <div class="col-sm-12">
                                    <div class="box box-success">
                                        <div class="box-header">
                                            <h4 class="box-title">Ringkasan</h4>
                                        </div>
                                        <div class="box-body">
                                            <div class="form-group">  
                                                <label>Kolektor Sebelumnya</label>
                                                <input type="text" class="form-control" id="PREV_KOLEKTOR" readonly="">
                                            </div> 
                                            <div class="form-group">
                                                <label>Kolektor Baru</label>
                                                <input type="text" class="form-control" id="NEW_KOLEKTOR" readonly="">
                                            </div> 
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div id="sisi-kanan">
                            <div class="box box-success">
                                <div class="box-header">
                                    <h4 class="box-title">Data Table</h4>
                                </div>
                                <div class="box-body">
                                    <div class="box-inner-scroll">
                                        <div class="data-kolektor-table-parent" style="width:97%;">
                                            <table id="data-kolektor-table"
                                                   class="table table-bordered table-hover table-striped table-angsuran">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 1%">No.</th>
                                                        <th style="width: 30%">Nomor Pegawai</th>
                                                        <th style="width: 55%">Nama</th>
                                                        <th style="width: 9%">Aksi</th>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div id="footer-bagian-bawah">
                        <input type="hidden" id="NEW_KOLEKTOR_ID" name="NEW_KOLEKTOR_ID" value="">
                        <input type="hidden" id="PINJAMAN_ID_MODAL" name="PINJAMAN_ID" value="">
                        <button type="button" class="btn btn-sm btn-danger" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Tutup</button>
                        <button type="button" id="pilih-kolektor-btn" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                    </div>
                </div>
            </div>

        </div>
    </div> 
                        
                        
                            
  </body>
</html>

