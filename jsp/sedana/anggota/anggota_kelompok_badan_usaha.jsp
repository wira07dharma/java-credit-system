<%-- 
    Document   : anggota_kelompok_badan_usaha
    Created on : Aug 25, 2017, 10:31:27 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstPosition"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Position"%>
<%@page import="com.dimata.sedana.entity.anggota.PengurusKelompok"%>
<%@page import="com.dimata.sedana.entity.anggota.PstPengurusKelompok"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstVocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Vocation"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.Ward"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstWard"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.SubRegency"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstSubRegency"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.Regency"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstRegency"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.Province"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstProvince"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.City"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstCity"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmAnggotaBadanUsaha"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.util.Formater"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% //
  long idKelompok = FRMQueryString.requestLong(request, "kelompok_id");
  int iCommand = FRMQueryString.requestCommand(request);

  String nomorBadanUsaha = "";

  AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
  if (iCommand == Command.EDIT && idKelompok != 0) {
    abu = PstAnggotaBadanUsaha.fetchExc(idKelompok);
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
      select option {padding: 5px;}

      .print-area { visibility: hidden; display: none; }
      .print-area.print-preview { visibility: visible; display: block; }
      @media print
      {
        body * { visibility: hidden; }
        .print-area * { visibility: visible; }
        .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
      }

      .tabel_data {
        border-collapse: collapse;
      }
      .tabel_data td {
        padding: 5px 8px;
      }
      .tabel_data th {
        padding: 5px 8px;
        font-size: 12px;
        font-weight: normal;
      }
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
        function pressEnter(elementIdEnter, elementIdFocus) {
          $(elementIdEnter).keypress(function (e) {
            if (e.keyCode === 13) {
              $(elementIdFocus).focus();
              var atr = $(elementIdEnter).attr('required');
              var val = $(elementIdEnter).val();
              if (atr === "required") {
                if (val === "") {
                  alert("Data tidak boleh kosong !");
                  $(elementIdEnter).focus();
                } else {
                  return false;
                }
              } else {
                return false;
              }
            }
          });
        }

        //MODAL SETTING
        var modalSetting = function (elementId, backdrop, keyboard, show) {
          $(elementId).modal({
            backdrop: backdrop,
            keyboard: keyboard,
            show: show
          });
        };

        $('#NAME').focus();
        pressEnter('#NAME', '#TLP');
        pressEnter('#TLP', '#EMAIL');
        pressEnter('#EMAIL', '#OFFICE_ADDRESS');
        pressEnter('#OFFICE_ADDRESS', '#ADDR_OFFICE_CITY');
        pressEnter('#ADDR_OFFICE_CITY', '#ID_CARD');
        pressEnter('#ID_CARD', '#NO_NPWP');
        pressEnter('#NO_NPWP', '#btn_save');

        $('#form_kelompok').submit(function () {
          var buttonName = $('#btn_save').html();
          $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

          var oid = $('#ID_ANGGOTA').val();
          var command = "<%=Command.SAVE%>";
          var dataFor = "saveKelompok";

          onDone = function (data) {
            var error = data.RETURN_ERROR_CODE;
            var kelompokId = data.RETURN_OID_KELOMPOK;
            if (error === "0") {
              alert(data.RETURN_MESSAGE);
              //window.location = "../anggota/anggota_kelompok_badan_usaha.jsp?kelompok_id=" + kelompokId + "&command=<%=Command.EDIT%>";
              window.location = "../anggota/pengurus_kelompok.jsp?kelompok_id=" + kelompokId;
            } else {
              alert(data.RETURN_MESSAGE);
            }
          };

          onSuccess = function (data) {
            $('#btn_save').removeAttr('disabled').html(buttonName);
          };

          var data = $(this).serialize();
          var dataSend = "" + data + "&FRM_FIELD_OID=" + oid + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command;
          //alert(JSON.stringify(dataSend));
          getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
          return false;
        });

        $('#btn_printNasabah').click(function () {
          var buttonHtml = $(this).html();
          $(this).attr({"disabled": "true"}).html("Tunggu...");
          window.print();
          $(this).removeAttr('disabled').html(buttonHtml);
        });

        $('#btn_cancel').click(function () {
          $(this).attr({"disabled": "true"}).html("Tunggu...");
          window.location = "../anggota/list_anggota_kelompok.jsp";
        });

      });
    </script>

  </head>
  <body style="background-color: #eaf3df;">

    <section class="content-header">
      <h1>
        Kelompok / Badan Usaha
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Master Bumdesa</li>
        <li class="active"><%=namaNasabah%></li>
      </ol>
    </section>

    <%if (idKelompok != 0) {%>
    <section class="content-header">
      <a class="btn btn-danger" href="../anggota/anggota_kelompok_badan_usaha.jsp?kelompok_id=<%=idKelompok%>&command=<%=Command.EDIT%>">Data Profil</a>
      <a style="background-color: white" class="btn btn-default" href="../anggota/pengurus_kelompok.jsp?kelompok_id=<%=idKelompok%>">Data Pengurus / Pemilik</a>
      <a style="background-color: white" class="btn btn-default" href="../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>">Data Tabungan</a>
      <a style="background-color: white" class="btn btn-default" href="../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>">Dokumen Bersangkutan</a>
      <a style="font-size: 14px" class="btn-box-tool" href="../anggota/list_anggota_kelompok.jsp">Kembali ke daftar <%=namaNasabah%></a>
    </section>
    <%}%>

    <section class="content">
      <div class="box box-success">

        <div class="box-header with-border" style="border-color: lightgrey">                    
          <h3 class="box-title">Form Input Kelompok / Badan Usaha</h3>
        </div>

        <p></p>

        <form id="form_kelompok" class="form-horizontal">
          <div class="box-body">

            <input type="hidden" value="<%=idKelompok%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_ANGGOTA]%>">

            <div class="form-group">
              <label class="control-label col-sm-2">Nomor Badan Usaha</label>
              <div class="col-sm-4">
                  <input type="text" placeholder="Otomatis jika kosong" class="form-control input-sm" value="<%=abu.getNoAnggota()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_ANGGOTA]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Nama Badan Usaha</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=abu.getName()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NAME_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NAME_ANGGOTA]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Nomor Telepon</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=abu.getTelepon()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_TLP]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_TLP]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Alamat Email</label>
              <div class="col-sm-4">
                <input type="text" class="form-control input-sm" value="<%=abu.getEmail()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_EMAIL]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_EMAIL]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Alamat Badan Usaha</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=abu.getOfficeAddress()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_OFFICE_ADDRESS]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_OFFICE_ADDRESS]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Kota Lokasi Badan Usaha</label>
              <div class="col-sm-4">
                <select class="form-control input-sm" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ADDR_OFFICE_CITY]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ADDR_OFFICE_CITY]%>">
                  <%
                    Vector<City> listCity = PstCity.list(0, 0, "", "");
                    for (int i = 0; i < listCity.size(); i++) {
                  %>

                  <%if (iCommand == Command.EDIT && abu.getAddressOfficeCity() == listCity.get(i).getOID()) {%>
                  <option selected="" value="<%=listCity.get(i).getOID()%>"><%=listCity.get(i).getCityName()%></option>
                  <%} else {%>
                  <option value="<%=listCity.get(i).getOID()%>"><%=listCity.get(i).getCityName()%></option>
                  <%}%>

                  <%
                    }
                  %>
                </select>                                
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Nomor Akte Pendirian</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=abu.getIdCard()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_CARD]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_CARD]%>">
              </div>
            </div>

            <div class="form-group">
              <label class="control-label col-sm-2">Nomor NPWP</label>
              <div class="col-sm-4">
                <input type="text" required="" class="form-control input-sm" value="<%=abu.getNoNpwp()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_NPWP]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_NPWP]%>">
              </div>
            </div>

          </div>

          <div class="box-footer" style="border-color: lightgrey">
            <div class="form-group" style="margin-bottom: 0px">
              <div class="col-sm-2"></div>
              <div class="col-sm-4">
                <div class="pull-right">
                  <button type="submit" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                  <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                  <%if (idKelompok != 0) {%>
                  <button type="button" id="btn_printNasabah" class="btn btn-sm btn-primary"><i class="fa fa-print"></i> &nbsp; Cetak</button>
                  <%}%>
                </div>
              </div>
            </div>
          </div>
        </form>

      </div>
    </section>

    <!--------------------------------------------------------------------->

    <div class="print-area">
      <div style="size: A5;" class="container">
        <div style="overflow: auto">
          <div style="width: 50%; float: left;">
            <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
            <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
            <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
          </div>
          <div style="width: 50%; float: right; text-align: right">
            <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DATA <%=namaNasabah.toUpperCase()%></span>
            <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
            <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
          </div>
        </div>
        <div class="clearfix"></div>
        <hr class="" style="border-color: gray">
        <!------------------------->
        <div>
          <strong>Data <%=namaNasabah%> &nbsp; : &nbsp;</strong>
        </div>
        <table class="tabel_data">
          <tr><td>Nomor Badan Usaha</td><td>&nbsp; : &nbsp;</td><td><%=abu.getNoAnggota()%></td></tr>
          <tr><td>Nama Badan Usaha</td><td>&nbsp; : &nbsp;</td><td><%=abu.getName()%></td></tr>
          <tr><td>Telepon</td><td>&nbsp; : &nbsp;</td><td><%=abu.getTelepon()%></td></tr>
          <tr><td>Email</td><td>&nbsp; : &nbsp;</td><td><%=abu.getEmail()%></td></tr>
          <tr><td>Alamat</td><td>&nbsp; : &nbsp;</td><td><%=abu.getOfficeAddress()%></td></tr>
          <tr><td>Nomor Akte Pendirian</td><td>&nbsp; : &nbsp;</td><td><%=abu.getIdCard()%></td></tr>
          <tr><td>Nomor NPWP</td><td>&nbsp; : &nbsp;</td><td><%=abu.getNoNpwp()%></td></tr>
        </table>
        <br>
        <div>
          <strong>Data Pengurus &nbsp; : &nbsp;</strong>
        </div>
        <table class="tabel_data" border="1" cellpadding="0" cellspacing="0">
          <tr>
            <th>No.</th>
            <th>Nama Pengurus</th>
            <th>Jenis Kelamin</th>
            <th>Jabatan</th>
            <th>Telepon</th>
            <th>Email</th>
            <th>Alamat</th>
            <th>Prosentase Kepengurusan</th>
            <th>Status Kepemilikan</th>
          </tr>
          <%
            Vector listPengurus = PstPengurusKelompok.list(0, 0, "" + PstPengurusKelompok.fieldNames[PstPengurusKelompok.FLD_ID_KELOMPOK] + " = '" + idKelompok + "'", "");
            for (int i = 0; i < listPengurus.size(); i++) {
              PengurusKelompok pk = (PengurusKelompok) listPengurus.get(i);
          %>
          <tr>
            <td><%=(i + 1)%></td>
            <td><%=pk.getNamaPengurus()%></td>
            <td><%=PengurusKelompok.GENDER_TITLE[pk.getJenisKelamin()]%></td>
            <% Position p = PstPosition.fetchExc(pk.getJabatan());%>
            <td><%=p.getPositionName()%></td>
            <td><%=pk.getTelepon()%></td>
            <td><%=pk.getEmail()%></td>
            <td><%=pk.getAlamat()%></td>
            <td><%=pk.getProsentaseKepengurusan()%> %</td>
            <td><%=PengurusKelompok.STATUS_KEPEMILIKAN_TITLE[pk.getStatusKepemilikan()]%></td>
          </tr>
          <%
            }
          %>

        </table>
        <br>
        <div>
          <strong>Data Tabungan &nbsp; : &nbsp;</strong>
        </div>
        <table class="tabel_data" border="1" cellpadding="0" cellspacing="0">
          <tr>
            <th>No.</th>
            <th>Nomor Tabungan</th>
            <th>Nama Tabungan</th>
            <th>Jenis Simpanan</th>
          </tr>
          <%
            Vector listTabungan = PstAssignContact.list(0, 0, "" + PstAssignContact.fieldNames[PstAssignContact.FLD_CONTACT_ID] + " = '" + idKelompok + "'", "");
            for (int i = 0; i < listTabungan.size(); i++) {
              AssignContact assignContact = (AssignContact) listTabungan.get(i);
              MasterTabungan mt = new MasterTabungan();
              JenisSimpanan js = new JenisSimpanan();
              String namaSimpanan = "";
              try {
                mt = PstMasterTabungan.fetchExc(assignContact.getMasterTabunganId());
                Vector<AssignTabungan> at = new Vector<AssignTabungan>();
                at = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + mt.getOID(), "");
                for (int in = 0; in < at.size(); in++) {
                  js = PstJenisSimpanan.fetchExc(at.get(in).getIdJenisSimpanan());
                  if (in == 0) {
                    namaSimpanan += js.getNamaSimpanan();
                  } else {
                    namaSimpanan += ", " + js.getNamaSimpanan();
                  }
                }

              } catch (Exception e) {

              }
          %>
          <tr>
            <td><%=(i + 1)%></td>
            <td><%=assignContact.getNoTabungan()%></td>
            <td><%=mt.getNamaTabungan()%></td>
            <td><%=namaSimpanan%></td>
          </tr>
          <%
            }
          %>
        </table>
      </div>
    </div>

  </body>
</html>
