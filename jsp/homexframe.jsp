<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.common.db.DBException"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.common.entity.contact.PstContactClassAssign"%>
<%@page import="com.dimata.common.entity.contact.ContactClassAssign"%>
<%@page import="com.dimata.sedana.entity.tabungan.MasterTabunganPenarikan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>

<%!
    public int cekTipeAnggota(long idAnggota) {
        Vector<ContactClassAssign> listAssigns = PstContactClassAssign.list(0, 0, PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = " + idAnggota, null);
        for (ContactClassAssign cca : listAssigns) {
            long idClassAssign = cca.getContactClassId();
            try {
                return PstContactClass.fetchExc(idClassAssign).getClassType();
            } catch (DBException dbe) {
                System.out.print(dbe.getMessage());
            }
        }
        return 0;
    }
%>

<%
    long oidCompany = PstCompany.getOidCompany();
    Company objCompany = new Company();
	Location loc = new Location();
	if(userLocationId != 0){
            loc = PstLocation.fetchFromApi(userLocationId);
//		loc = PstLocation.fetchExc(userLocationId);
	} else {
            Vector listTemp = PstLocation.getListFromApi(0, 0, "", "");
            if(!listTemp.isEmpty()){
                loc = (Location) listTemp.get(0);
            }
        }
    if (oidCompany != 0){
        objCompany = PstCompany.fetchExc(oidCompany);
    }
    String lokasiAmbilFoto = PstSystemProperty.getValueByName("COMP_IMAGE_GET_PATH");
	int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
%>  
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>SEDANA - Sistem Manajemen Simpan Pinjam</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <%@ include file = "/style/lte_head.jsp" %>
  </head>
  <body class="hold-transition skin-green sidebar-mini" style="background-color: #ffffff;">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <div class="">
            <center><img src="./images/sedana-logo.png" style="display: inline-block; width: 50px;" /></center><br>   
            <p align="center">
              <b>Dimata SEDANA</b><br>
              Sistem Manajemen Sewa Beli
            </p>
            <center><br><i>Untuk</i></br></center>
            <% if (!lokasiAmbilFoto.equals("") && (!objCompany.getCompImage().equals("") && objCompany.getCompImage() != null)){ %>
                <img style="margin: auto; display: block; width: 160px; text-align: center; margin-top: 20px;" src="<%=lokasiAmbilFoto%>/<%=objCompany.getCompImage()%>" alt="User Image"><br>
            <% } else { %>
                <img style="margin: auto; display: block; width: 160px; text-align: center; margin-top: 20px;" src="./images/company_logo.jpg" ><br>
            <% } %>
            <br>
            <center>
                <!--<h2><%=compName%></h2>-->
                <!--<h3><%=compAddr%></h3>-->
                <h2><%= loc.getName() %></h2>
                <h3><%= loc.getAddress() %></h3>
            </center>
            <br>
            <div>
                <h3>Informasi :</h3>
                
                <%
					if (enableTabungan == 1) {
                    //cek apakah ada tabungan deposito yg jatuh tempo di bulan ini dan bulan depan
                    Vector<Vector> listDeposito = SessReportTabungan.getListTabunganDepositoYangAkanBerakhir();
                %>
                <h5>Tabungan deposito mendekati masa berakhir &nbsp; : &nbsp;
                    <% if (listDeposito.isEmpty()) {%>
                    <span><%= listDeposito.size()%> data tabungan</span>
                    <% } else {%>
                    <a data-toggle="collapse" href="#deposito"><%= listDeposito.size()%> data tabungan</a>
                    <% } %>
                </h5>
                <ul id="deposito" class="collapse">
                <%
                    for (Vector v : listDeposito) {
                        Anggota a = (Anggota) v.get(0);
                        AssignContactTabungan act = (AssignContactTabungan) v.get(1);
                        MasterTabungan mt = (MasterTabungan) v.get(2);
                        DataTabungan dt = (DataTabungan) v.get(3);
                        MasterTabunganPenarikan mtp = (MasterTabunganPenarikan) v.get(4);

                        int tipeAnggota = cekTipeAnggota(a.getOID());
                        String link = "";
                        if (tipeAnggota == PstContactClass.CONTACT_TYPE_MEMBER) {
                            link = "masterdata/anggota/anggota_tabungan.jsp?anggota_oid=" + a.getOID();
                        }
                        if (tipeAnggota == PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA) {
                            link = "sedana/anggota/kelompok_tabungan.jsp?kelompok_id=" + a.getOID();
                        }

                        String nama = a.getName();
                        String nomorTabungan = mt.getNamaTabungan();
                        String tglTutup = Formater.formatDate(dt.getTanggalTutup(), "dd MMM yyyy");
                %>
                <li>
						<a href="<%= link%>"><%= nama%></a>
						&nbsp; <%= nomorTabungan%>
                    &nbsp; Berakhir pada
						&nbsp; <a style="color: red"><%= tglTutup%></a>
                </li>
                <%
                    }
						}
                %>
                </ul>
                
                <%
                    //cek apakah ada angsuran kredit yg jatuh tempo di bulan ini dan bulan depan yg belum lunas
                    Vector<Vector> listKreditJatuhTempo = SessReportTabungan.getListJadwalAngsuranKreditYangAkanJatuhTempo();
                %>
                <h5>Angsuran kredit belum lunas bulan ini &nbsp; : &nbsp; 
                    <% if (listKreditJatuhTempo.isEmpty()) { %>
                    <span><%= listKreditJatuhTempo.size() %> data kredit</span>
                    <% } else { %>
                    <a data-toggle="collapse" href="#kredit"><%= listKreditJatuhTempo.size() %> data kredit</a>
                    <% } %>
                </h5>
                <ul id="kredit" class="collapse">
                <%
                    for (Vector v : listKreditJatuhTempo) {
                        JenisKredit jk = (JenisKredit) v.get(0);
                        Anggota a = (Anggota) v.get(1);
                        JadwalAngsuran ja = (JadwalAngsuran) v.get(2);
                        Angsuran ang = (Angsuran) v.get(3);
                        
                        String link = "sedana/transaksikredit/jadwal_angsuran.jsp?pinjaman_id=" + ja.getPinjamanId();
                %>
                <li>
                    <a href="<%= link %>"><%= a.getName() %></a>
                    &nbsp; <%= jk.getNamaKredit() %>
                    &nbsp; <a style="color: red"><%= Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy") %></a>
                </li>
                <%
                    }
                %>
                </ul>
            </div>
            <br>
            <br>
            <br>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
    </section>
    <!-- /.content -->
    <%@ include file = "/footerkoperasi.jsp" %>
  </body>
</html>