<%-- 
    Document   : pengurus_company
    Created on : Dec 3, 2017, 10:03:57 PM
    Author     : dimata005
--%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstPosition"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Position"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.form.anggota.FrmPengurusKelompok"%>
<%@page import="com.dimata.sedana.entity.anggota.PengurusKelompok"%>
<%@page import="com.dimata.sedana.entity.anggota.PstPengurusKelompok"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.util.Formater"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% //
  long idKelompok = FRMQueryString.requestLong(request, "kelompok_id");
  long idPengurus = FRMQueryString.requestLong(request, "pengurus_id");
  int iCommand = FRMQueryString.requestCommand(request);

  AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
  if (idKelompok != 0) {
    abu = PstAnggotaBadanUsaha.fetchExc(idKelompok);
  }
  String checked = "";
  PengurusKelompok pengurus = new PengurusKelompok();
  if (iCommand == Command.EDIT && idPengurus != 0) {
    pengurus = PstPengurusKelompok.fetchExc(idPengurus);
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
      th {text-align: center; font-weight: normal}
      select option {padding: 5px;}
    </style>
    <script language="javascript">
      $(document).ready(function () {

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

        //check required on enter
        function pressEnterEmpty(elementIdEnter, elementIdFocus) {
          $(elementIdEnter).keypress(function (e) {
            if (e.keyCode === 13) {
              $(elementIdFocus).focus();
              return false;
            }
          });
        }
        function pressEnter2(elementIdEnter, elementIdFocus) {
          $(elementIdEnter).keypress(function (e) {
            if (e.keyCode === 13) {
              var atr = $(elementIdEnter).attr('required');
              var val = $(elementIdEnter).val();
              if (val === "") {
                if (atr === "required") {
                  alert("Data tidak boleh kosong !");
                  $(elementIdEnter).focus();
                } else if (typeof atr === typeof undefined) {
                  $(elementIdFocus).focus();
                }
              } else {
                $(elementIdFocus).focus();
              }
              return false;
            }
          });
        }
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

        $('#btn_add').click(function () {
          $(this).attr({"disabled": "true"}).html("Tunggu...");
          window.location = "../masterbumdes/pengurus_company.jsp?kelompok_id=<%=idKelompok%>&pengurus_id=0&command=<%=Command.ADD%>";
        });

        $('.btn_edit').click(function () {
          $(this).attr({"disabled": "true"}).html("....");
          var oidPengurus = $(this).data('oid');
          window.location = "../masterbumdes/pengurus_company.jsp?pengurus_id=" + oidPengurus + "&command=<%=Command.EDIT%>";
        });

        $('#btn_cancel').click(function () {
          $(this).attr({"disabled": "true"}).html("Tunggu...");
          window.location = "../masterbumdes/pengurus_company.jsp?kelompok_id=<%=idKelompok%>";
        });

        //set focus
        $('#NAMA_PENGURUS').focus();
        pressEnter('#NAMA_PENGURUS', '#JABATAN');
        pressEnter('#JABATAN', '#TELEPON');
        pressEnter('#TELEPON', '#EMAIL');
        pressEnter('#EMAIL', '#ALAMAT');
        pressEnter('#ALAMAT', '#PROSENTASE_KEPENGURUSAN');
        pressEnter('#PROSENTASE_KEPENGURUSAN', '#STATUS');
        pressEnter('#STATUS', '#btn_save');
        $('#MALE').click(function () {
          $('#JABATAN').focus();
        });
        $('#FEMALE').click(function () {
          $('#JABATAN').focus();
        });

        $('#FORM_PENGURUS').submit(function () {
          var buttonName = $('#btn_save').html();
          $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

          var oid = $('#ID_PENGURUS').val();
          var command = "<%=Command.SAVE%>";
          var dataFor = "savePengurus";

          onDone = function (data) {
            var error = data.RETURN_ERROR_CODE;
            if (error === "1") {
              alert(data.RETURN_MESSAGE);
            } else {
              alert(data.RETURN_MESSAGE);
              window.location = "../masterbumdes/pengurus_company.jsp?kelompok_id=<%=idKelompok%>";
            }
          };

          onSuccess = function (data) {
            $('#btn_save').removeAttr('disabled').html(buttonName);
          };

          var data = $(this).serialize();
          var dataSend = "" + data + "&FRM_FIELD_OID=" + oid + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command;
          getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
          return false;
        });

        $('#btn_delete').click(function () {
          if (confirm("Yakin ingin menghapus data ini ?")) {
            var buttonName = $('#btn_delete').html();
            $('#btn_delete').attr({"disabled": "true"}).html("Tunggu...");

            var oid = $('#ID_PENGURUS').val();
            var command = "<%=Command.DELETE%>";
            var dataFor = "deletePengurus";
            var dataSend = {
              "FRM_FIELD_OID": oid,
              "FRM_FIELD_DATA_FOR": dataFor,
              "command": command
            };
            onDone = function (data) {
              var error = data.RETURN_ERROR_CODE;
              if (error === "0") {
                alert(data.RETURN_MESSAGE);
                window.location = "../masterbumdes/pengurus_company.jsp?kelompok_id=<%=idKelompok%>";
              } else if (error === "1") {
                alert(data.RETURN_MESSAGE);
              }
            };
            onSuccess = function (data) {
              $('#btn_delete').removeAttr('disabled').html(buttonName);
            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
            return false;
          }
        });

      });
    </script>
  </head>
  <body style="background-color: #eaf3df;">

    <section class="content-header">
      <h1>
        Data Pengurus Organisasi
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Master Bumdesa</li>
        <li class="active">Data Pengurus Organisasi</li>
      </ol>
    </section>

    <%if (idKelompok == 0) {%>
    <section class="content-header">
      <a class="btn btn-default " href="../masterbumdes/company_edit.jsp?kelompok_id=0&command=<%=Command.EDIT%>">Data Perusahaan</a>
      <a class="btn btn-danger" href="../masterbumdes/pengurus_company.jsp?kelompok_id=0">Data Pengurus</a>
    </section>
    <%}%>

    <section class="content">
      <div class="box box-success">
        <div class="box-body">
          <label>Daftar Pengurus</label>
          <div style="width: 100%">
            <table class="table table-bordered table-striped">
              <tr class="label-success">
                <th style="width: 1%">No.</th>
                <th>Nama Pengurus</th>
                <th>Jenis Kelamin</th>
                <th>Jabatan</th>
                <th>Telepon</th>
                <th>Email</th>
                <th>Alamat</th>
                <th>Prosentase Kepengurusan</th>
                <th>Status Kepemilikan</th>
                <th style="width: 1%">Aksi</th>
              </tr>

              <% Vector listPengurus = PstPengurusKelompok.list(0, 0, "" + PstPengurusKelompok.fieldNames[PstPengurusKelompok.FLD_ID_KELOMPOK] + " IS NULL ", ""); %>

              <% if (listPengurus.isEmpty()) { %>

              <tr><td class="text-center label-default" colspan="10">Tidak ada data pengurus</td></tr>

              <% } else { %>

              <%
                for (int i = 0; i < listPengurus.size(); i++) {
                  PengurusKelompok pk = (PengurusKelompok) listPengurus.get(i);
              %>

              <tr>
                <td><%=(i + 1)%></td>
                <td><%=pk.getNamaPengurus()%></td>
                <td><%=PengurusKelompok.GENDER_TITLE[pk.getJenisKelamin()]%></td>
                <% Position p = PstPosition.fetchExc(pk.getJabatan()); %>
                <td><%=p.getPositionName()%></td>
                <td><%=pk.getTelepon()%></td>
                <td><%=pk.getEmail()%></td>
                <td><%=pk.getAlamat()%></td>
                <td><%=pk.getProsentaseKepengurusan()%> %</td>
                <td><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[pk.getStatusKepemilikan()]%></td>
                <td class="text-center"><button class="btn btn-xs btn-warning btn_edit" data-oid="<%=pk.getOID()%>"><i class="fa fa-pencil"></i></button></td>
              </tr>

              <%
                }
              %>

              <% }%>

            </table>
          </div>
        </div>

        <div class="box-footer" style="border-color: lightgrey">
          <% if (idKelompok == 0) {%>
          <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Pengurus</button>
          <% }%>
        </div>
      </div>

      <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>

      <div class="box box-success">

        <div class="box-header with-border" style="border-color: lightgrey">
          <h3 class="box-title">Form Input Pengurus</h3>
        </div>

        <p></p>

        <form id="FORM_PENGURUS" class="form-horizontal" method="post">
          <div class="box-body">

            <input type="hidden" value="<%=idKelompok%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_ID_KELOMPOK]%>" id="ID_KELOMPOK">
            <input type="hidden" value="<%=idPengurus%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_ID_PENGURUS]%>" id="ID_PENGURUS">

            <div class="form-group">
              <label class="control-label col-sm-2">Nama Pengurus</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=pengurus.getNamaPengurus()%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_NAMA_PENGURUS]%>" id="NAMA_PENGURUS">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Jenis Kelamin</label>
              <div class="col-sm-4">
                <div class="radio col-sm-6">
                  <%
                    checked = "";
                    if (iCommand == Command.EDIT && pengurus.getJenisKelamin() == PengurusKelompok.GENDER_MALE) {
                      checked = "checked";
                    }
                  %>
                  <label><input type="radio" value="<%=PengurusKelompok.GENDER_MALE%>" <%=checked%> name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_JENIS_KELAMIN]%>" id="MALE"><%=PengurusKelompok.GENDER_TITLE[PengurusKelompok.GENDER_MALE]%></label>
                </div>
                <div class="radio col-sm-6">
                  <%
                    checked = "";
                    if (iCommand == Command.EDIT && pengurus.getJenisKelamin() == PengurusKelompok.GENDER_FEMALE) {
                      checked = "checked";
                    }
                  %>
                  <label><input type="radio" value="<%=PengurusKelompok.GENDER_FEMALE%>" <%=checked%> name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_JENIS_KELAMIN]%>" id="FEMALE"><%=PengurusKelompok.GENDER_TITLE[PengurusKelompok.GENDER_FEMALE]%></label>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Jabatan</label>
              <div class="col-sm-4">
                <select class="form-control input-sm" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_JABATAN]%>" id="JABATAN">
                  <%
                    Vector<Position> jabatans = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION_NAME]);
                    for (Position j : jabatans) {
                  %>
                  <option <%=(pengurus.getJabatan()==j.getOID()?"selected":"")%> value="<%=j.getOID()%>"><%=j.getPositionName()%></option>
                  <%}%>
                </select>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Telepon</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=pengurus.getTelepon()%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_TELEPON]%>" id="TELEPON">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Email</label>
              <div class="col-sm-4">
                <input type="text" class="form-control input-sm" value="<%=pengurus.getEmail()%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_EMAIL]%>" id="EMAIL">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Alamat</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=pengurus.getAlamat()%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_ALAMAT]%>" id="ALAMAT">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Prosentase Kepengurusan</label>
              <div class="col-sm-4">
                <div class="input-group">
                  <input type="number" max="100" required="" class="form-control input-sm" value="<%=pengurus.getProsentaseKepengurusan()%>" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_PROSENTASE_KEPENGURUSAN]%>" id="PROSENTASE_KEPENGURUSAN">
                  <span class="input-group-addon">%</span>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Status</label>
              <div class="col-sm-4">
                <select class="form-control input-sm" name="<%=FrmPengurusKelompok.fieldNames[FrmPengurusKelompok.FRM_FIELD_STATUS_KEPEMILIKAN]%>" id="STATUS">                                    
                  <%if (iCommand == Command.EDIT && pengurus.getStatusKepemilikan() == PengurusKelompok.STATUS_KEPEMILIKAN_AKTIF) {%>
                  <option value="<%=PengurusKelompok.STATUS_KEPEMILIKAN_AKTIF%>" selected=""><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[PengurusKelompok.STATUS_KEPEMILIKAN_AKTIF]%></option>
                  <%} else {%>
                  <option value="<%=PengurusKelompok.STATUS_KEPEMILIKAN_AKTIF%>"><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[PengurusKelompok.STATUS_KEPEMILIKAN_AKTIF]%></option>
                  <%}%>    

                  <%if (iCommand == Command.EDIT && pengurus.getStatusKepemilikan() == PengurusKelompok.STATUS_KEPEMILIKAN_TIDAK_AKTIF) {%>
                  <option value="<%=PengurusKelompok.STATUS_KEPEMILIKAN_TIDAK_AKTIF%>" selected=""><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[PengurusKelompok.STATUS_KEPEMILIKAN_TIDAK_AKTIF]%></option>
                  <%} else {%>
                  <option value="<%=PengurusKelompok.STATUS_KEPEMILIKAN_TIDAK_AKTIF%>"><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[PengurusKelompok.STATUS_KEPEMILIKAN_TIDAK_AKTIF]%></option>
                  <%}%>
                </select>
              </div>
            </div>

          </div>

          <div class="box-footer" style="border-color: lightgray">
            <div class="form-group" style="margin-bottom: 0px">
              <div class="col-sm-2"></div>
              <div class="col-sm-4">
                <div class="pull-right">
                  <button type="submit" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                  <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                  <% if (iCommand == Command.EDIT) {%>
                  <button type="button" id="btn_delete" class="btn btn-sm btn-danger pull-right"><i class="fa fa-remove"></i> &nbsp; Hapus</button>
                  <% }%>
                </div>
              </div>
            </div>                        
          </div>
        </form>

      </div>

      <% }%>
    </section>
  </body>
</html>
