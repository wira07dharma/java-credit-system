<%-- 
    Document   : print_jadwal_angsuran
    Created on : Dec 2, 2019, 10:29:38 PM
    Author     : WiraDharma
--%>

<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktu"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktu"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    long tellerShiftId = 0;
    if (userOID != 0) {
        Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
        if (open.size() < 1) {
            String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/list_kredit.jsp";
            response.sendRedirect(redirectUrl);
        } else {
            tellerShiftId = open.get(0).getOID();
        }
    }
    
    int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA"); 
    long oidPinjaman = FRMQueryString.requestLong(request, FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]);
	
    int iCommand = FRMQueryString.requestCommand(request);
    Pinjaman pinjaman = new Pinjaman();
    Anggota nasabah = new Anggota();
    try {
        pinjaman = (Pinjaman) PstPinjaman.fetchExc(oidPinjaman);
        nasabah = PstAnggota.fetchExc(pinjaman.getAnggotaId());
    } catch (Exception exc) {

    }
    int jangkaWaktu = 0;
    JangkaWaktu jk = new JangkaWaktu();
    try {
        jk = PstJangkaWaktu.fetchExc(pinjaman.getJangkaWaktuId());
      } catch (Exception e) {
      }
    jangkaWaktu = jk.getJangkaWaktu();
    
    boolean tidakAdaTransaksiPembayaran = SessKredit.getListAngsuranByPinjaman(pinjaman.getOID()).isEmpty();
    
    DecimalFormat df = new DecimalFormat("#.##");
    String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
    
response.setContentType("application/x-msexcel"); 
response.setHeader("Content-Disposition","attachment; filename=" + "Jadwal Angsuran Kredit.xls" ); 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Export Excel</title>
    <style>

      th {
            text-align: center;
        }
        td {
            text-align: center;
        }

    </style>
    </head>
    <body>
            <form id="formJadwalPrint" class="form-horizontal">
                <div style="width: 50%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                </div>
                <div>
                    <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                    <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
                </div>                    
                <div style="width: 50%; float: right; text-align: right">                    
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">JADWAL ANGSURAN KREDIT</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userFullName%></span>                    
                </div>
                <div class="clearfix"></div>
                <hr class="" style="border-color: gray">
                <div>
                    <span style="width: 120px; float: left;">Nomor Kredit</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getNoKredit()%></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Nama <%=namaNasabah%></span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=nasabah.getName()%></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Jumlah Pinjaman</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; Rp <a style="color: black" class="money"><%= FRMHandler.userFormatStringDecimal(pinjaman.getJumlahPinjaman()) %></a></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Jangka Waktu</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=jangkaWaktu%> kali angsuran</span>
                </div>
                <div class="clearfix"></div>
                <div>
                    <h4 style="text-align: center"><b>Jadwal Angsuran</b></h4>
                </div>
                <div>
                    <table class="table table-striped table-bordered" style="width:100%" border="1">
                        <thead>
                            <tr>
                                <th rowspan="2" style="width: 1%">No.</th>
                                <th rowspan="2">Jatuh Tempo</th>
                                <th colspan="2">Angsuran</th>
                                <th colspan="2">Denda</th>
                                <th rowspan="2">No. Kwitansi</th>
                                <th rowspan="2">Keterangan</th>
                            </tr>
                            <tr>
                                <th>Jumlah</th>
                                <th>Dibayar</th>
                                <th>Jumlah</th>
                                <th>Dibayar</th>
                            </tr>
                        </thead>
                        <tbody>

                            <%
                                Vector listJadwal = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                        + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN], PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                                
                                double totalPokok = 0;
                                double totalPokokDibayar = 0;
                                double totalDenda = 0;
                                double totalDendaDibayar = 0;
                                
                                for (int i = 0; i < listJadwal.size(); i++) {
                                    JadwalAngsuran ja = (JadwalAngsuran) listJadwal.get(i);
                                    Vector listAngsuran = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + ja.getTanggalAngsuran() + "'", "");
                                    double pokok = 0;
                                    double pokokDibayar = 0;
                                    double denda = 0;
                                    double dendaDibayar = 0;
                                    String status = "";
                                    int belumLunas = 0;
                                    for (int la = 0; la < listAngsuran.size(); la++) {
                                        JadwalAngsuran angsuran = (JadwalAngsuran) listAngsuran.get(la);
                                        if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                                            pokok = angsuran.getJumlahANgsuran();
                                            totalPokok += pokok;
                                            pokokDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, angsuran.getTanggalAngsuran().toString());
                                            totalPokokDibayar += pokokDibayar;
                                            double newPokok = Double.valueOf(df.format(pokok));
                                            double newPokokDibayar = Double.valueOf(df.format(pokokDibayar));
                                            belumLunas += (newPokokDibayar >= newPokok) ? 0 : 1;
                                        } else if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
                                            denda = angsuran.getJumlahANgsuran();
                                            totalDenda += denda;
                                            dendaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_DENDA, angsuran.getTanggalAngsuran().toString());
                                            totalDendaDibayar += dendaDibayar;
                                            double newDenda = Double.valueOf(df.format(denda));
                                            double newDendaDibayar = Double.valueOf(df.format(dendaDibayar));
                                            belumLunas += (newDendaDibayar >= newDenda) ? 0 : 1;
                                        }
                                    }
                                    status = (belumLunas > 0) ? "Belum lunas" : "Lunas";
                            %>

                            <tr>
                                <td class="text-center"><%=(i + 1)%></td>
                                <td class="text-center"><%=Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy")%></td>
                                <td class="money text-right"><%= FRMHandler.userFormatStringDecimal(pokok)%></td>
                                <td class="money text-right"><%= FRMHandler.userFormatStringDecimal(pokokDibayar)%></td>
                                <td class="money text-right"><%= FRMHandler.userFormatStringDecimal(denda)%></td>
                                <td class="money text-right"><%= FRMHandler.userFormatStringDecimal(dendaDibayar)%></td>
                                <td class="text-center"><%=ja.getNoKwitansi() %></td>
                                <td class="text-center"><%=status%></td>
                            </tr>

                            <%
                                }
                            %>
                            
                            <tr>
                                <th colspan="2" class="text-right">TOTAL</th>
                                <th class="money text-right"><%= FRMHandler.userFormatStringDecimal(totalPokok) %></th>
                                <th class="money text-right"><%= FRMHandler.userFormatStringDecimal(totalPokokDibayar) %></th>
                                <th class="money text-right"><%= FRMHandler.userFormatStringDecimal(totalDenda) %></th>
                                <th class="money text-right"><%= FRMHandler.userFormatStringDecimal(totalDendaDibayar) %></th>
                                <th></th>
                                <th></th>
                            </tr>
                            
                        </tbody>
                    </table>
                </div>

                <div class="clearfix"></div>

                <div style="width: 100%;padding-top: 40px;">
                    <div style="width: 50%;float: left;text-align: center;">
                        <span>Petugas</span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                </div>
            </form>
    </body>
</html>
