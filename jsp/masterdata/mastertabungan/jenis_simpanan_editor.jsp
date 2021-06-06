<%-- 
    Document   : jenis_kredit_editor
    Created on : Aug 24, 2018, 2:00:21 PM
    Author     : Regen
--%>

<%@page import="com.dimata.sedana.entity.masterdata.TingkatanBunga"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstTingkatanBunga"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.FrmJenisSimpanan"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.CtrlJenisSimpanan"%>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>

<%@include file="../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    long oidJenisSimpanan = FRMQueryString.requestLong(request, "hidden_jenisSimpanan_id");
    int iErrCode = FRMMessage.NONE;
    String msgString = "";
    CtrlJenisSimpanan ctrlJenisSimpanan = new CtrlJenisSimpanan(request);
    iErrCode = ctrlJenisSimpanan.action(iCommand, oidJenisSimpanan);
    FrmJenisSimpanan frmJenisSimpanan = ctrlJenisSimpanan.getForm();
    JenisSimpanan jenisSimpanan = ctrlJenisSimpanan.getJenisSimpanan();
    msgString = ctrlJenisSimpanan.getMessage();
    iCommand = (iCommand == Command.ADD || iCommand == Command.EDIT ? Command.SAVE : iCommand);
%>

<!DOCTYPE html>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <title>Edit Jenis Item</title>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Edit Jenis Item
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/sedana/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Bumdesa</li>
                <li class="active">Jenis Item </li>
                <li class="active">Jenis Item Editor </li>
            </ol>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-xs-12">
                    <!-- Horizontal Form -->
                    <form class="box box-success" action="?command=<%=Command.SAVE%>">
                        <div class="box-header with-border">
                            <h3 class="box-title">Jenis Item Editor </h3>
                            <input type="hidden" name="command" value="<%=iCommand%>">
                            <input type="hidden" name="hidden_jenisSimpanan_id" value="<%=oidJenisSimpanan%>">
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <style>
                                        .form-group > .input-group { margin-bottom: 10px !important; }
                                        .form-group > .input-group > .input-group-addon { min-width: 148px !important; text-align: right !important; }
                                    </style>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <span class="input-group-addon">Nama</span>
                                            <input type="text" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_NAMA_SIMPANAN]%>" value="<%=jenisSimpanan.getNamaSimpanan()%>" required="" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Setoran Minimal</span>
                                            <input type="hidden" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_SETORAN_MIN]%>" class="hidden-val">
                                            <input type="text" style="text-align: right;" value="<%=jenisSimpanan.getSetoranMin()%>" required="" class="form-control money" data-cast-class="hidden-val">
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Provisi</span>
                                            <input type="hidden" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_PROVISI]%>" class="hidden-val">
                                            <input type="text" style="text-align: right;" value="<%=jenisSimpanan.getProvisi()%>" required="" class="form-control money" data-cast-class="hidden-val">
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Biaya Admin Bulanan</span>
                                            <input type="hidden" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BIAYA_ADMIN]%>" class="hidden-val">
                                            <input type="text" style="text-align: right;" value="<%=jenisSimpanan.getBiayaAdmin()%>" required="" class="form-control money" data-cast-class="hidden-val">
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Frekuensi Setoran</span>
                                            <select required="" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_FREKUENSI_SIMPANAN]%>" class="form-control">
                                                <% for (int i = 0; i < JenisSimpanan.FREKUENSI_SIMPANAN_TITLE.length; i++) {%>
                                                <option <%=(jenisSimpanan.getFrekuensiSimpanan() == i ? "selected" : "")%> value="<%=i%>"><%=(JenisSimpanan.FREKUENSI_SIMPANAN_TITLE[i])%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Frekuensi Penarikan</span>
                                            <select required="" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_FREKUENSI_PENARIKAN]%>" class="form-control">
                                                <% for (int i = 0; i < JenisSimpanan.FREKUENSI_PENARIKAN_TITLE.length; i++) {%>
                                                <option <%=(jenisSimpanan.getFrekuensiPenarikan() == i ? "selected" : "")%> value="<%=i%>"><%=(JenisSimpanan.FREKUENSI_PENARIKAN_TITLE[i])%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Basis Hari Bunga</span>
                                            <input type="number" max="365" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_BASIS_HARI_BUNGA]%>" value="<%=jenisSimpanan.getBasisHariBunga()%>" required="" class="form-control">
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">Keterangan</span>
                                            <textarea name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_DESC_JENIS_SIMPANAN]%>" class="form-control"><%=jenisSimpanan.getDescJenisSimpanan()%></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h4>Bunga</h4>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <span class="input-group-addon">Jenis Bunga</span>
                                            <select required="" name="<%=FrmJenisSimpanan.fieldNames[FrmJenisSimpanan.FRM_FIELD_JENIS_BUNGA]%>" class="form-control">
                                                <% for (int ix = 0; ix < JenisSimpanan.BUNGA.size(); ix++) {%>
                                                <option <%=(jenisSimpanan.getJenisBunga() == ix ? "selected" : "")%> value="<%=ix%>"><%=JenisSimpanan.BUNGA.get(ix)[SESS_LANGUAGE]%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="table-responsive bunga">
                                        <style>
                                            .bunga table tr > * { border: 1px solid #bbb !important; }
                                            table.table .form-control { margin: 0 !important; height: 39px !important; }
                                            table.table .td-input { padding: 0 !important; }
                                            table.table .form-control { border-color: rgba(0,0,0,0); }
                                            table.table .form-control:focus { border-color: blue; }
                                        </style>
                                        <table class="table table-bordered" id="table-bunga">
                                            <thead>
                                                <tr>
                                                    <th style="text-align:right; background-color:#ddd;">Min. Saldo</th>
                                                    <th style='background-color:#ddd;'>Bunga (%)</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% Vector<TingkatanBunga> tingkatan = PstTingkatanBunga.list(0, 0, PstTingkatanBunga.fieldNames[PstTingkatanBunga.FLD_ID_JENIS_SIMPANAN] + "=" + jenisSimpanan.getOID(), PstTingkatanBunga.fieldNames[PstTingkatanBunga.FLD_NOMINAL_SALDO_MIN]); %>
                                                <% for (TingkatanBunga tb : tingkatan) {%>
                                                <tr>
                                                    <td class='td-input'>
                                                        <input type='hidden' name='ID_BUNGA' value="<%=tb.getOID()%>">
                                                        <input type='hidden' name='BUNGA_SALDO_MIN' class='hidden-val'>
                                                        <input style='text-align: right' style='text-align: right !important;' class='form-control money' value='<%=tb.getNominalSaldoMin()%>' data-cast-class='hidden-val'>
                                                    </td>
                                                    <td class='td-input'>
                                                        <input type='hidden' name='BUNGA_VAL' class='hidden-val'>
                                                        <input data-max='100' class='form-control money' value='<%=tb.getPersentaseBunga()%>' data-cast-class='hidden-val'>
                                                    </td>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                        <button type="button" style='margin-top:-15px;' id='add-bunga' class="btn btn-default pull-right"><i class="fa fa-plus"></i></button>
                                        <script>
                                            $(window).load(function () {
                                                $("#add-bunga").click(function () {
                                                    var input = $("<tr> <td class='td-input'> <input type='hidden' name='ID_BUNGA'> <input type='hidden' name='BUNGA_SALDO_MIN' class='hidden-val'> <input style='text-align: right' class='form-control money' value='0' data-cast-class='hidden-val'> </td> <td class='td-input'> <input type='hidden' name='BUNGA_VAL' class='hidden-val'> <input data-max='100' class='form-control money' value='0' data-cast-class='hidden-val'> </td> </tr>");
                                                    $(input).find(".money").each(function () {
                                                        jMoney(this);
                                                    });
                                                    $("#table-bunga tbody").append(input);
                                                });
                                            });
                                        </script>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="pull-right">
                                <button type="submit" class="btn btn-sm btn-success right"><i class="fa fa-check"></i> Simpan</button>
                                <a href='jenis_simpanan.jsp' class="btn btn-sm btn-primary "><i class="fa fa-arrow-left"></i> Kembali</a>
                                <% if(jenisSimpanan.getOID() != 0) {%>
                                <a href="jenis_simpanan.jsp?command=<%=(Command.ACTIVATE)%>&hidden_jenisSimpanan_id=<%=(oidJenisSimpanan)%>" type="button" id="delete" class="btn btn-sm btn-danger"><i class="fa fa-remove"></i> Hapus</a>
                                <%}%>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </section>
        <% if (msgString != null && !msgString.equals("")) {%>
        <script>
        if ("<%= iCommand%>" === "<%= Command.SAVE%>" && "<%= iErrCode%>" === "0") {
            window.location = "jenis_simpanan.jsp";
        }
        </script>
        <%}%>
    </body>
</html>
