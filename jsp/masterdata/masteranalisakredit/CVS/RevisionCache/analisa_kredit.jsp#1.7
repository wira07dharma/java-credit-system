<%-- 
    Document   : masteranalisakredit
    Created on : Nov 21, 2019, 11:06:08 AM
    Author     : arise
--%>

<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.form.analisakredit.FrmMasterAnalisaKredit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_KREDIT, AppObjInfo.OBJ_ANALISA_MASTER); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
	response.sendRedirect(approot + "/nopriv.html"); 
}
%>

<%!
	public static final String textHeader[][] = {
		{"Master Group", "Analisa Kredit", "List Master"},
		{"Master Group", "Credit Analysis", "Master List"}
	};

	public static final String textCrud[][] ={
		{"Tambah", "Ubah", "Hapus", "Simpan"},
		{"Add", "Update", "Delete", "Save"}
	};

	public static final String textHeaderTable[][] = {
		{"No.", "Kode", "Group", "Deskripsi", "Aksi"},
		{"No.", "Code", "Group", "Description", "Action"}
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
						<div id="master-anaisa-table-parent">
							<table id="master-analisa-table" class="table table-bordered table-striped table-responsive">
								<thead>
									<tr>
										<th style="width: 1%"> <%= textHeaderTable[SESS_LANGUAGE][0]%> </th>
										<th style="width: 20%"> <%= textHeaderTable[SESS_LANGUAGE][1]%> </th>
										<th style="width: 20%"> <%= textHeaderTable[SESS_LANGUAGE][2]%> </th>
										<th style="width: 40%"> <%= textHeaderTable[SESS_LANGUAGE][3]%> </th>
										<th style="width: 10%"> <%= textHeaderTable[SESS_LANGUAGE][4]%> </th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-success open-master-modal" value="0">
							<i class="fa fa-plus"></i>&nbsp;
							<%= textCrud[SESS_LANGUAGE][0]%>
						</button>
					</div>
				</div>
			</section>
		</div>


		<div id="modal-master-group" class="modal fade no-print" role="dialog">
			<div class="modal-dialog">                
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
						<h4 class="modal-title judul text-bold">JUDUL</h4>
					</div>

					<div class="modal-body">
						<div class="row">
							<div class="col-md-12">
								<form id="<%= FrmMasterAnalisaKredit.FRM_NAME_MASTERANALISAKREDIT %>">
								</form>
							</div>
						</div>
					</div>

					<div class="modal-footer">
						<button type="button" id="btn_close" value="0"
								class="btn btn-success update-master-btn">
							<i class="fa fa-save"></i>&nbsp;
							<%= textCrud[SESS_LANGUAGE][3]%>
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
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
						"order":[[1]],
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST %>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor,
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
                    dataTablesOptions("#master-analisa-table-parent", "master-analisa-table", "AjaxAnalisaKredit", "listMasterAnalisaKredit", null);
                }
				
				$('body').on('click', '.open-master-modal', function (){
					var oid = $(this).val();
					modalSetting('#modal-master-group', 'static', false, false);
					var modal = $('#modal-master-group');
					modal.modal('show');
					var modalTitle = "";
					if(oid == 0){
						modalTitle = "<%= textCrud[SESS_LANGUAGE][0] %>";
					} else {
						modalTitle = "<%= textCrud[SESS_LANGUAGE][1] %>";
					}
					modal.find('.judul').html(modalTitle + " <%= textHeader[SESS_LANGUAGE][0] %>");
					modal.find('.modal-footer .update-master-btn').val(oid);
					var form = $('#<%= FrmMasterAnalisaKredit.FRM_NAME_MASTERANALISAKREDIT %>');

					$.ajax({
						type: 'POST',
						url:"<%= approot %>/AjaxAnalisaKredit?FRM_FIELD_DATA_FOR=showMasterAnalisaForm&ANALISA_OID="+oid,
						dataType: 'json',
						case: false,
						beforeSend: function () {
							var loading = $('#loading-spinner');
							loading.css({
								"position":"relative",
								"margin":"auto 50%"
							});
							form.html(loading);
						},
						success: function (data) {
							var showForm = data.FRM_FIELD_HTML;
							form.html(showForm);
						}
					}).done();
				});
				$('body').on('click', '.update-master-btn', function(){
					var formData = $('#<%= FrmMasterAnalisaKredit.FRM_NAME_MASTERANALISAKREDIT %>');
					var oid = $(this).val();
					var modal = $('#modal-master-group');
					var btnName = $(this).html();
					$(this).attr({"disabled": "true"}).html("Tunggu...");
					$.ajax({
						type: 'POST',
						url: "<%= approot %>/AjaxAnalisaKredit?command=<%= Command.SAVE %>&FRM_FIELD_DATA_FOR=saveMasterAnalisaKredit&ANALISA_OID="+oid,
						data: formData.serialize(),
						dataType: 'json',
						cache: false,
						success: function (data) {
							let code = data.RETURN_ERROR_CODE;
							let type = "";
							if(code < 0){
								type = "error";
							} else {
								type = "success";
							}
							fireSwal('center', type, data.RETURN_MESSAGE);
							runDataTable();
							$('.update-master-btn').removeAttr('disabled').html(btnName);
							modal.modal('hide');
						}
					}).done();
				});
				
				$('body').on('click', '.delete-master-btn', function(){
					var oid = $(this).val();
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
						var url = "<%= approot %>/AjaxAnalisaKredit?SESS_LANGUAGE=<%= SESS_LANGUAGE %>&command=<%= Command.DELETE %>&FRM_FIELD_DATA_FOR=deleteMasterAnalisa&ANALISA_OID="+oid;
						$.ajax({
							type: 'POST',
							url: url,
							dataType: 'json',
							case: false,
							success: function (data) {
								let code = data.RETURN_ERROR_CODE;
								let type = "";
								if(code < 0){
									type = "error";
								} else {
									type = "success";
								}
								fireSwal('center', type, data.RETURN_MESSAGE);
								runDataTable()();
							} 
						}).done();
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
