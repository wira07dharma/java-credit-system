<%-- 
    Document   : jangkaWaktuFormula
    Created on : Jan 8, 2020, 10:25:50 AM
    Author     : arise
--%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmJangkaWaktuFormula"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.form.analisakredit.FrmMasterAnalisaKredit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%!
	public static final String textHeader[][] = {
		{"Formula", "Jangka Waktu", "List Formula", "Simulasi", "Kalkulasi"},
		{"Formula", "Time Period", "Formula List", "Simulation", "Calculate"}
	};

	public static final String textCrud[][] ={
		{"Tambah", "Ubah", "Hapus", "Simpan"},
		{"Add", "Update", "Delete", "Save"}
	};

	public static final String textHeaderTable[][] = {
		{"No.", "Jangka Waktu", "Tipe Transaksi", "Formula", "Aksi", "Kode", "Nama", "Indeks", "Jenis Komponen", "Pembulatan"},
		{"No.", "Time Period", "Transaction Type", "Formula", "Action", "Code", "Name", "Index", "Comp Type", "Rounding"}
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
	public static String textAlert[][] = {
		{"Anda yakin ingin menghapus data ini?", "Anda tidak dapat mengembalikan data jika sudah terhapus."},
		{"Are you sure want to delete this data?", "You wont be able to restore the data once it's deleted."}
	};
%>
<%
    long oidJangkaWaktu = FRMQueryString.requestLong(request, "hidden_jangka_waktu_id");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<%@include file="../../style/style_kredit.jsp" %>

		<style>
			.lds-dual-ring {
				display: inline-block;
				width: 80px;
				height: 80px;
			}
			.lds-dual-ring:after {
				content: " ";
				display: block;
				width: 24px;
				height: 24px;
				margin: 8px;
				border-radius: 50%;
				border: 4px solid #00a65a;
				border-color: #00a65a transparent #00a65a transparent;
				animation: lds-dual-ring 1.2s linear infinite;
			}
			@keyframes lds-dual-ring {
				0% {
					transform: rotate(0deg);
				}
				100% {
					transform: rotate(360deg);
				}
			}
			.loading-pos{
				position: fixed;
				bottom: 0;
				right: 0;
				
			}

			.popup-class{
				display: flex;
				width: 40%;
				height: 50%;
				font-size: small;
			}
		</style>

    </head>
    <body style="background-color: #eaf3df;">

		<div class="main-page">

			<!-- ===== HEADER ===== -->
			<section class="content-header">
				<h1>
					<%= textHeader[SESS_LANGUAGE][0]%> <small><%= textHeader[SESS_LANGUAGE][1]%></small>
				</h1>
				<ol class="breadcrumb">
					<li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
				</ol>
			</section>

			<!-- ===== CONTENT ===== -->
			<section class="content">
				<div class="box box-success">
					<div class="box-header with-border border-gray">
						<h3 class="box-title"> <%= textHeader[SESS_LANGUAGE][2]%> </h3>
					</div>
					<div class="box-body">
                                            <div class="form-group row">
                                                <label for="jeniskredit" class="col-sm-2 col-form-label">Jenis Kredit : </label>
                                                <div class="col-sm-3">
                                                    <select name="jeniskredit" class="form-control" id="jeniskredit">
                                                        <option value="0">Global</option>
                                                        <%
                                                            Vector listJenisKredit = PstJenisKredit.list(0, 0, "", "");
                                                            if (listJenisKredit.size()>0){
                                                                for (int i = 0; i < listJenisKredit.size(); i++){
                                                                    JenisKredit jenisKredit = (JenisKredit) listJenisKredit.get(i);
                                                                    %><option value="<%=jenisKredit.getOID()%>"><%=jenisKredit.getNamaKredit()%></option><%
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group row">
                                                <label for="status" class="col-sm-2 col-form-label">Status : </label>
                                                <div class="col-sm-3">
                                                    <select name="jeniskredit" class="form-control" id="status">
                                                        <option value="0">Aktif</option>
                                                        <option value="1">Non Aktif</option>
                                                    </select>
                                                </div>
                                            </div>        
						<div id="master-formula-table-parent">
							<table id="master-formula-table" class="table table-bordered table-striped table-responsive">
								<thead>
									<tr>
										<th style="width: 1%"> <%= textHeaderTable[SESS_LANGUAGE][7]%> </th>
										<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][5]%> </th>
										<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][6]%> </th>
                                                                                <th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][8]%> </th>
                                                                                <th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][9]%> </th>
										<th style="width: 40%"> <%= textHeaderTable[SESS_LANGUAGE][3]%> </th>
										<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][4]%> </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<div class="box-footer">
                                                <div><p>
                                                        <b>* Nilai Deposit pada pengajuan kredit akan mengambil komponen dengan jenis DP</b><br>
                                                        <b>** Nilai Jumlah Pengajuan pada Form Pengajuan Kredit akan mengambil komponen dengan jenis Nilai Pengajuan</b><br>
                                                        <b>*** Komponen akan di proses berurutan sesuai indeks yang telah di tetapkan</b>
                                                    </p>
                                                </div>
						<button type="button" class="btn btn-success open-modal-master-formula" value="0">
							<i class="fa fa-plus"></i>&nbsp;
							<%= textCrud[SESS_LANGUAGE][0]%>
						</button> 
                                                <button type="button" class="btn btn-success open-modal-simulasi" >
							<i class="fa fa-refresh"></i>&nbsp;
							<%= textHeader[SESS_LANGUAGE][3]%>
						</button>
					</div>
				</div>
			</section>
		</div>


                <div id="modal-master-formula" class="modal fade no-print" role="dialog">
                    <div class="modal-dialog">                
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title judul text-bold">JUDUL</h4>
                            </div>

                            <div class="modal-body">
                                <div class="row">
                                    <form id="<%= FrmJangkaWaktuFormula.FRM_NAME_JANGKAWAKTUFORMULA%>">

                                    </form>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" id="btn_close" value="0"
                                        class="btn btn-success save-master-formula">
                                    <i class="fa fa-save"></i>&nbsp;
                                    <%= textCrud[SESS_LANGUAGE][3]%>
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
                                
                <div id="modal-simulasi" class="modal fade no-print" role="dialog">
                    <div class="modal-dialog modal-lg">                
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title judul text-bold">Simulasi Formula Kredit</h4>
                            </div>

                            <div class="modal-body">
                                <div class="row">
                                    <form id="FRM_SIMULASI">
                                        <input type="hidden" name="OID_JANGKA_WAKTU" value="<%=oidJangkaWaktu%>">
                                        <div class="col-md-3">
                                            <div clas="form-group">
                                                <label>Jenis Kredit</label>
                                                <select name="jKredit" class="form-control" id="jeniskredit">
                                                    <option value="0">Global</option>
                                                    <%
                                                        listJenisKredit = PstJenisKredit.list(0, 0, "", "");
                                                        if (listJenisKredit.size()>0){
                                                            for (int i = 0; i < listJenisKredit.size(); i++){
                                                                JenisKredit jenisKredit = (JenisKredit) listJenisKredit.get(i);
                                                                %><option value="<%=jenisKredit.getOID()%>"><%=jenisKredit.getNamaKredit()%></option><%
                                                            }
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div clas="form-group">
                                                <label>HPP</label>
                                                <input name="hpp" class="form-control" value="0">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div clas="form-group">
                                                <label>DP</label>
                                                <input name="dp" class="form-control" value="0">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div clas="form-group">
                                                <label>Kenaikan (%)</label>
                                                <input name="increase" class="form-control" value="0">
                                            </div>
                                        </div>
                                        <div class="col-md-12 simulasi-container" style="margin-top: 10px">
                                            
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" id="btn_close" value="0"
                                        class="btn btn-success calculate">
                                    <i class="fa fa-refresh"></i>&nbsp;
                                    <%= textHeader[SESS_LANGUAGE][4]%>
                                </button>
                            </div>

                        </div>
                    </div>
                </div>

		<div class="loading-pos">
			<div id="loading-spinner" class="lds-dual-ring"></div>
		</div>
						
		<script>
			$(function(){
				$('.select2').select2();
				
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
				let textAlertTitle = "<%= textAlert[SESS_LANGUAGE][0] %>";
				let textAlertDesc = "<%= textAlert[SESS_LANGUAGE][1] %>";
				function fireSwal(position, type, message){
					Swal.fire({
						position: position,
						icon: type,
						title: message,
						customClass: swalClasses
					});
				};
				//send ajax function
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
                    var datafilter = "";
                    let jenisKredit = $("#jeniskredit option:selected").val();
                    let status = $("#status option:selected").val();
                    var privUpdate = "";
					let transType = $('#TIPE_TRANSAKSI').val() - 1;
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
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
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST %>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&FRM_FIELD_TIPE_TRANS=" + transType+"&OID_JANGKA_WAKTU="+<%=oidJangkaWaktu%>+"&JENIS_KREDIT_ID="+jenisKredit+"&STATUS="+status,
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
                }
				function runDataTable() {
                    dataTablesOptions("#master-formula-table-parent", "master-formula-table", "AjaxJangkaWaktu", "listMasterFormula", null);
                }
                
                $( "#jeniskredit" ).change(function() {
                    runDataTable();
                  });
                  $( "#status" ).change(function() {
                    runDataTable();
                  });
				$('body').on('change', '#TIPE_TRANSAKSI', function(){
					runDataTable();
				});
                                $('body').on('click', '.calculate', function(){
                                        let btnHtml = $(this).html();
					$(this).html("Tunggu...").attr({"disabled": "true"});
					let form = $('#FRM_SIMULASI');					
					$.ajax({
						type: 'POST',
						url: "<%= approot %>/AjaxJangkaWaktu?command=<%= Command.NONE %>&SESS_LANGUAGE=<%= SESS_LANGUAGE %>&FRM_FIELD_DATA_FOR=calculateSimulation",
						data: form.serialize(),
						dataType: 'json',
						cache: false,
						success: function (data) {
						}
					}).done(function (data) {
						$(".simulasi-container").html(data.FRM_FIELD_HTML);
                                                $('.calculate').removeAttr('disabled').html(btnHtml);
					});
				});
				$('body').on('click', '.open-modal-master-formula', function(){
					//initialize some variable using let
					let modal = $('#modal-master-formula');
                                        let jenisKredit = $("#jeniskredit option:selected").val();
                                        let status = $("#status option:selected").val();
					modalSetting('#modal-master-formula', 'static', false, false);
					let oid = $(this).val();
					let title = "";
					if(oid == 0){
						title = "<%= textCrud[SESS_LANGUAGE][0] %>";
					} else {
						title = "<%= textCrud[SESS_LANGUAGE][1] %>";
					}
					title += " <%= textHeader[SESS_LANGUAGE][0] %>";
					
					//go for the modal
					modal.modal('show');
					modal.find('.modal-header .judul').html(title);
					
					let form = $('#<%= FrmJangkaWaktuFormula.FRM_NAME_JANGKAWAKTUFORMULA %>');
					
					$.ajax({
						type: 'POST',
						url:"<%= approot %>/AjaxJangkaWaktu?FRM_FIELD_DATA_FOR=showMasterFormulaForm&MASTER_OID="+oid+"&OID_JANGKA_WAKTU=<%=oidJangkaWaktu%>&JENIS_KREDIT_ID="+jenisKredit+"&STATUS="+status,
						dataType: 'json',
						case: false,
						beforeSend: function () {
							let loading = $('#loading-spinner');
							loading.css({
								//"position":"relative",
								"margin":"auto 50%"
							});
							form.html(loading);
						},
						success: function (data) {
						}
					}).done(function(data){
						var showForm = data.FRM_FIELD_HTML;
						form.html(showForm);
					});
				});
                                
                                $('body').on('click', '.open-modal-simulasi', function(){
					//initialize some variable using let
					let modal = $('#modal-simulasi');
					modalSetting('#modal-simulasi', 'static', false, false);
					
					//go for the modal
					modal.modal('show');
					
				});
                                
				$('body').on('click', '.save-master-formula', function(){
					let btnHtml = $(this).html();
					$(this).html("Tunggu...").attr({"disabled": "true"});
					let modal = $('#modal-master-formula');
					let form = $('#<%= FrmJangkaWaktuFormula.FRM_NAME_JANGKAWAKTUFORMULA %>');					
					$.ajax({
						type: 'POST',
						url: "<%= approot %>/AjaxJangkaWaktu?command=<%= Command.SAVE %>&SESS_LANGUAGE=<%= SESS_LANGUAGE %>&FRM_FIELD_DATA_FOR=saveMasterFormula",
						data: form.serialize(),
						dataType: 'json',
						cache: false,
						success: function (data) {
						}
					}).done(function (data) {
						let code = data.RETURN_ERROR_CODE;
						let type = "";
						if(code < 0){
							type = "error";
						} else {
							type = "success";
						}
						fireSwal('center', type, data.RETURN_MESSAGE);
						runDataTable();
						$('.save-master-formula').removeAttr('disabled').html(btnHtml);
						modal.modal('hide');
					});
				});
				$('body').on('click', '.delete-master-formula', function(){
					let oid = $(this).val();
					Swal.fire({
						position: 'center',
						icon: 'warning',
						title: textAlertTitle,
						text: textAlertDesc,
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: 'Yes',
						customClass: swalClasses
					}).then((result) => {
					  if (result.value) {
						var url = "<%= approot %>/AjaxJangkaWaktu?command=<%= Command.DELETE %>&SESS_LANGUAGE=<%= SESS_LANGUAGE %>&FRM_FIELD_DATA_FOR=deleteMasterFormula&MASTER_OID="+oid;
						$.ajax({
							type: 'POST',
							url: url,
							dataType: 'json',
							case: false,
							success: function (data) {
							} 
						}).done(function (data) {
							let code = data.RETURN_ERROR_CODE;
							let type = "";
							if(code < 0){
								type = "error";
							} else {
								type = "success";
							}
							fireSwal('center', type, data.RETURN_MESSAGE);
							runDataTable()();
						});
					  }
					});
				});
				
				runDataTable();
			});
			

			$(document).ajaxStart(function(){
				$('#loading-spinner').show();
			});
			$(document).ajaxComplete(function(){
				$('#loading-spinner').hide();
			});
		</script>
    </body>
</html>
