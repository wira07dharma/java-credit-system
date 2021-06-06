<%@ page import="com.dimata.sisbkd.entity.admin.AppObjInfo,
				 com.dimata.util.blob.TextLoader,
				 java.io.FileOutputStream,
				 java.io.ByteArrayInputStream,
				 java.io.InputStream,
				 org.apache.poi.hssf.usermodel.HSSFDateUtil,
				 com.dimata.util.Excel,
				 com.dimata.util.Formater,
				 com.dimata.sisbkd.entity.masterdata.*,
				 com.dimata.sisbkd.entity.datainduk.*,
				 com.dimata.qdep.form.FRMQueryString,
				 com.dimata.util.Command"%>
<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DATA_MASTER, AppObjInfo.G2_DATA_MASTER_JABATAN, AppObjInfo.OBJ_DM_ESELON); %>
<%@ include file = "../main/checkuser.jsp" %>

<!-- JSP Block -->
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>SisBKD</title>
<script language="javascript">
function cmdBack(){
	document.frmPns.command.value="<%=Command.BACK%>";
	document.frmPns.action="<%=approot%>/home.jsp";
	document.frmPns.submit();
}
</script>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../styles/default.css" rel="stylesheet" type="text/css">
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
  <!--DWLayoutTable-->
  <tr>
    <td height="76" width="100%" colspan="3" valign="top"> <table height=76 cellspacing=0 cellpadding=0 width="100%" border=0>
      <!--DWLayoutTable-->
      <tr>
        <td id=TOPTITLE valign=top width="100%" background=../images/menubg.gif
          bgcolor=#66BB8A height=50>
          <table cellspacing=0 cellpadding=0 width="100%" border=0>
            <tr>
                <td width="25%" height=20><img
                  src="../images/logo2.gif" width=63 height=60 hspace="5"></td>
                <td align=center width="50%"><font size="3"><b><font color="#FFFFFF">Sistem
                  Badan Kepegawaian Daerah<br>
                  -SisBKD- </font></b></font></td>
              <td align=right width="25%"><img
                  src="../images/logo2.gif" width=63 height=60 hspace="5"></td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td valign=top align=middle height=2><img height=1
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td height=1 align=middle valign=top class="bordercolor"><img height=1
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td valign=top align=middle height=1><img height=1
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td height="17" align=center valign=center class="footer" id=MAINMENU> <!-- #BeginEditable "menumain" -->
            <%@ include file = "../main/home_mnmain.jsp" %>
            <!-- #EndEditable --></td>
      </tr>
      <tr>
        <td align=middle colspan=3 height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td height=1 align=middle class="bordercolor"><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
    </table></td>
  </tr>
  
  <tr> 
    <td valign="top" ><table cellspacing=1 cellpadding=0 width="100%" 
      border=0>
      <tr>
        <td valign=top bgcolor="#307857" >
          <table cellspacing=1 cellpadding=12 width="100%" border=0>
            <tr>
              <td valign=top bgcolor=#DFF4E4>                <!-- #BeginEditable "content" -->
					<form name="frmPns" method="post" action="">
				       <input type="hidden" name="command" value="">
					   <%
					   		Vector vPnsAdd = new Vector();
							String[] arrNip = request.getParameterValues("nip");
							String[] arrNama = request.getParameterValues("nama");
							String[] arrPej_menetapkan = request.getParameterValues("pej_menetapkan");
							String[] arrNomor_sk = request.getParameterValues("nomor_sk");
							String[] arrTgl_sk = request.getParameterValues("tanggal_sk");
							String[] arrPangkat = request.getParameterValues("pangkat");
							String[] arrGolongan = request.getParameterValues("golongan");
							String[] arrTmtPns = request.getParameterValues("tmt_pns");
							String[] arrSumpah = request.getParameterValues("sumpah");
							String strError = "";
							
							Hashtable lsHastPejabat = PstPejabat.getListPejabat();
							Hashtable lsHastGolongan = PstGolongan.getListGolongan();
							Hashtable lsHastPns = PstPns.getListPns();
							
							boolean transferSuccess = false;
							Vector verr = new Vector();
							Pns pnsReal = new Pns();
							
							for(int i=0;i<arrNip.length;i++)
							{
								Pns objPnsDtBase = (Pns)lsHastPns.get(arrNip[i].toUpperCase());
								
								//untuk dapat oid pejabat
								String pejabatCek = String.valueOf(arrPej_menetapkan[i]);
								long pejabatReal = 0;
								if(pejabatCek.equalsIgnoreCase("AA")){
									pejabatReal = 0;
								}
								else{
									Pejabat pejabat = (Pejabat)lsHastPejabat.get(arrPej_menetapkan[i].toUpperCase());
									pejabatReal = pejabat.getOID();
								}
								
								//untuk dapat oid golongan
								String golonganCek = String.valueOf(arrGolongan[i]);
								long golongan_real = 0;
								if(golonganCek.equalsIgnoreCase("AA")){
									golongan_real = 0;
								}
								else{
									Golongan golongan = (Golongan)lsHastGolongan.get(arrGolongan[i].toUpperCase());
									golongan_real = golongan.getOID();
								}
								
								
								
								String tanggal_Cek = arrTgl_sk[i];
								Date tanggalSkReal = new Date();
								
								if(tanggal_Cek.equalsIgnoreCase("00")){
									String tanggalSk = "0000-00-00";
									tanggalSkReal = Formater.formatDate(tanggalSk, "dd-MM-yyyy");
									/*int tanggal_Sk = tanggalSkReal.getDate()-30;
									int bln_Sk = tanggalSkReal.getMonth()-12;
									int thn_Sk = tanggalSkReal.getYear()-2;
									Date presenceDateTime = new Date(thn_Sk, bln_Sk, tanggal_Sk);
									System.out.println("tanggal_Sk::::::::::::::::::"+presenceDateTime);*/
								}
								else{
									String tanggalSk = arrTgl_sk[i];
									Date tanggal_Sk = Formater.formatDate(tanggalSk, "dd-MM-yyyy");
									String tanggalSk1 = Formater.formatDate(tanggal_Sk,"yyyy-MM-dd");
									tanggalSkReal = Formater.formatDate(tanggalSk1, "yyyy-MM-dd");
								}
								
								String tanggal_PnsCek = arrTmtPns[i];
								Date tanggalTmtReal = new Date();
								if(tanggal_PnsCek.equalsIgnoreCase("00")){
									//tanggalTmtReal = new Date();
									String str_tmt_Pns = "0000-00-00";
									tanggalTmtReal = Formater.formatDate(str_tmt_Pns, "dd-MM-yyyy");
								}
								else{
									String tmtPns = arrTmtPns[i];
									Date tmt_Pns= Formater.formatDate(tmtPns, "dd-MM-yyyy");
									String tmtPns1 = Formater.formatDate(tmt_Pns,"yyyy-MM-dd");
									tanggalTmtReal = Formater.formatDate(tmtPns1, "yyyy-MM-dd");
								}
								
								
								
								//untuk oid Sumpah
								String pnsSumpah = String.valueOf(arrSumpah[i]);
								int status_sumpah = 0;
								if(pnsSumpah.equalsIgnoreCase("SUDAH"))
									status_sumpah = 1;
								else
									status_sumpah = 2;
									
								
								Date dtNow = new Date();
								//untuk data identitas PNS
								pnsReal.setOID(objPnsDtBase.getOID());
								pnsReal.setNip(objPnsDtBase.getNip());
								pnsReal.setNama(objPnsDtBase.getNama());
								pnsReal.setGelarDepan(objPnsDtBase.getGelarDepan());
								pnsReal.setGelarBelakang(objPnsDtBase.getGelarBelakang());
								pnsReal.setTempatLahir(objPnsDtBase.getTempatLahir());
								pnsReal.setTanggalLahir(objPnsDtBase.getTanggalLahir());
								pnsReal.setJenisKelamin(objPnsDtBase.getJenisKelamin());
								pnsReal.setIdAgama(objPnsDtBase.getIdAgama());
								pnsReal.setIdStatusKepegawaian(objPnsDtBase.getIdStatusKepegawaian());
								pnsReal.setTipePegawai(objPnsDtBase.getTipePegawai());
								pnsReal.setIdJenisKepegawaian(objPnsDtBase.getIdJenisKepegawaian());
								pnsReal.setIdKedudukanPegawai(objPnsDtBase.getIdKedudukanPegawai());
								pnsReal.setStatusKawin(objPnsDtBase.getStatusKawin());
								pnsReal.setAlamat(objPnsDtBase.getAlamat());
								pnsReal.setAlamatRt(objPnsDtBase.getAlamatRt());
								pnsReal.setAlamatRw(objPnsDtBase.getAlamatRw());
								pnsReal.setAlamatTlp(objPnsDtBase.getAlamatTlp());
								pnsReal.setKodePos(objPnsDtBase.getKodePos());
								pnsReal.setIdDesa(objPnsDtBase.getIdDesa());
								pnsReal.setIdKecamatan(objPnsDtBase.getIdKecamatan());
								pnsReal.setIdKabupaten(objPnsDtBase.getIdKabupaten());
								pnsReal.setIdPropinsi(objPnsDtBase.getIdPropinsi());
								pnsReal.setGolonganDarah(objPnsDtBase.getGolonganDarah());
								pnsReal.setNrKarpeg(objPnsDtBase.getNrKarpeg());
								pnsReal.setNrAskes(objPnsDtBase.getNrAskes());
								pnsReal.setNrTasPen(objPnsDtBase.getNrTasPen());
								pnsReal.setNrKarisKarsu(objPnsDtBase.getNrKarisKarsu());
								pnsReal.setNrNpwp(objPnsDtBase.getNrNpwp());
								
								
								
								//untuk CPNS 
								pnsReal.setCpnsBknNr(objPnsDtBase.getCpnsBknNr());
								pnsReal.setCpnsBknTgl(objPnsDtBase.getCpnsBknTgl());
								pnsReal.setCpnsIdPejabat(objPnsDtBase.getCpnsIdPejabat());
								pnsReal.setCpnsSkNr(objPnsDtBase.getCpnsSkNr());
								pnsReal.setCpnsSkTgl(objPnsDtBase.getCpnsSkTgl());
								pnsReal.setMsKerjaThn(0);
								pnsReal.setMsKerjaBln(0);
								pnsReal.setCpnsIdGolongan(objPnsDtBase.getCpnsIdGolongan());
								pnsReal.setCpnsTmt(objPnsDtBase.getCpnsTmt());
								
								//untuk PNS
								pnsReal.setPnsIdPejabat(pejabatReal);								
								pnsReal.setPnsSkNr(arrNomor_sk[i]);
								pnsReal.setPnsSkTgl(tanggalSkReal);
								pnsReal.setPnsIdGolongan(golongan_real);
								pnsReal.setPnsTmt(tanggalTmtReal);
								pnsReal.setPnsSumpah(status_sumpah);
								pnsReal.setMsKerjaThnPns(0);
								pnsReal.setMsKerjaBlnPns(0);
								
								
								try{
									PstPns.updateExc(pnsReal);
									transferSuccess = true;
								}catch(Exception e){
									System.out.println("Insert error : " + e);
								}
							}
							
							   if(transferSuccess){
									out.println("Upload data sukses ...");
									out.println("<br><br><div class=\"command\"><a href=\"javascript:cmdBack()\">Kembali ke Menu Utama</a></div>");
								}else{
									out.println("<font color=\"#FF0000\">Upload data gagal ...</font>");
								}
							
					   %>
					  </form>
                  <!-- #EndEditable --></td>
            </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr> 
    <td width="100%" colspan="3" valign="bottom"> <table cellspacing=0 cellpadding=0 width="100%" border=0>
      <!--DWLayoutTable-->
      <tr>
        <td width="100%" height=5 align=middle valign=top><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td valign=top height=18><!-- #BeginEditable "useraccount" --> 
            <%@ include file = "../main/useraccount.jsp" %>
            <!-- #EndEditable --></td>
      </tr>
      <tr>
        <td height=1 align=middle valign=top class="bordercolor"><img 
            src="../Templates/home_files/spacer.gif" width=1 height=1 class="bordercolor"></td>
      </tr>
      <tr>
        <td valign=top align=middle height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td height="20" align=center valign=center class=footer ><!-- #BeginEditable "footer" --> 
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable --></td>
      </tr>
      <tr>
        <td valign=top align=middle height=1><img height=1 
            src="../Templates/home_files/spacer.gif" width=1></td>
      </tr>
      <tr>
        <td height=1 align=middle class="bordercolor"><img height=1 src="../Templates/home_files/spacer.gif" 
  width=5></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
