<%@ page import="com.dimata.sisbkd.entity.admin.AppObjInfo,
			 com.dimata.util.blob.TextLoader,
			 java.io.FileOutputStream,
			 java.io.ByteArrayInputStream,
			 java.io.InputStream,
			 org.apache.poi.hssf.usermodel.HSSFDateUtil,
			 com.dimata.util.Excel,
			 com.dimata.qdep.form.FRMQueryString"%>
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
					<%
					// ngambil/upload file sesuai dengan yang dipilih oleh "browse"
					TextLoader uploader = new TextLoader();
					FileOutputStream fOut = null;
					Vector v = new Vector();
				    Vector vectErr = new Vector();
					try{
						uploader.uploadText(config, request, response);
                        String str = uploader.getRequestText("col_sheet");
                        System.out.println("objSheet.toString() : "+str);
						Object obj = uploader.getTextFile("file");

						byte byteText[] = null;
						byteText = (byte[]) obj;
						ByteArrayInputStream inStream;
						inStream = new ByteArrayInputStream(byteText);
						Excel tp = new Excel();
						
						int numcol = 26;
                        if(Integer.parseInt(str)==0){
                            numcol = 26;
                        }else if(Integer.parseInt(str)==1){
                            numcol = 8;
                        }else if(Integer.parseInt(str)==2){
                            numcol = 9;
                        }else if(Integer.parseInt(str)==3){
                            numcol = 13;
                        }else if(Integer.parseInt(str)==4){
                            numcol = 13;
                        }else if(Integer.parseInt(str)==5){
                            numcol = 6;
                        }else if(Integer.parseInt(str)==6){
                            numcol = 5;
                        }else if(Integer.parseInt(str)==7){
                            numcol = 6;
                        }else if(Integer.parseInt(str)==8){
                            numcol = 13;
                        }else if(Integer.parseInt(str)==9){
                            numcol = 5;
                        }else if(Integer.parseInt(str)==10){
                            numcol = 7;
                        }else if(Integer.parseInt(str)==11){
                            numcol = 6;
                        }else if(Integer.parseInt(str)==12){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==13){
                            numcol = 5;
                        }else if(Integer.parseInt(str)==14){
                            numcol = 8;
                        }else if(Integer.parseInt(str)==15){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==16){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==17){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==18){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==19){
                            numcol = 10;
                        }else if(Integer.parseInt(str)==20){
                            numcol = 10;
                        }
						
						v = tp.ReadStream((InputStream) inStream, numcol,Integer.parseInt(str),0);
						double dt = 0.0;
						
						// proses untuk data dp stock employee
						if(Integer.parseInt(str)==0){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"importpnssave.jsp\">");
                            out.println("&nbsp;<b>Daftar PNS</b>");
                        }else if(Integer.parseInt(str)==1){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_cpns_save.jsp\">");
                            out.println("&nbsp;<b>Daftar pengangkatan CPNS</b>");
                        }else if(Integer.parseInt(str)==2){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_pns_save.jsp\">");
                            out.println("&nbsp;<b>Daftar pengangkatan PNS</b>");
                        }else if(Integer.parseInt(str)==3){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_daftar_ortu_ayah_save.jsp\">");
                            out.println("&nbsp;<b>Daftar Nama Ayah</b>");
                        }else if(Integer.parseInt(str)==4){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_daftar_ortu_ibu_save.jsp\">");
                            out.println("&nbsp;<b>Daftar Nama Ibu</b>");
                        }else if(Integer.parseInt(str)==5){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_pangkat_pns.jsp\">");
                            out.println("&nbsp;<b>Daftar Pangkat Pns</b>");
                        }else if(Integer.parseInt(str)==6){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_kenaikan_gaji_bkl.jsp\">");
                            out.println("&nbsp;<b>Daftar Kenaikan Gaji Berkala Pns</b>");
                        }else if(Integer.parseInt(str)==7){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_tmp_kerja_pns.jsp\">");
                            out.println("&nbsp;<b>Daftar Tempat Kerja PNS</b>");
                        }else if(Integer.parseInt(str)==8){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_jabatan_pns.jsp\">");
                            out.println("&nbsp;<b>Daftar Jabatan</b>");
                        }else if(Integer.parseInt(str)==9){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_hkm_disiplin.jsp\">");
                            out.println("&nbsp;<b>Daftar Hukuman Disiplin PNS</b>");
                        }else if(Integer.parseInt(str)==10){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_keanggotaan_pns.jsp\">");
                            out.println("&nbsp;<b>Daftar Keanggotaan PNS</b>");
                        }else if(Integer.parseInt(str)==11){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_tnd_jasa.jsp\">");
                            out.println("&nbsp;<b>Daftar Tanda Jasa</b>");
                        }else if(Integer.parseInt(str)==12){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_penugasan_pns.jsp\">");
                            out.println("&nbsp;<b>Daftar Penugasaan Luar Negeri</b>");
                        }else if(Integer.parseInt(str)==13){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_penguasaaan_bahasa.jsp\">");
                            out.println("&nbsp;<b>Daftar Penguasaan Bahasa</b>");
                        }else if(Integer.parseInt(str)==14){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_pndk_umum.jsp\">");
                            out.println("&nbsp;<b>Daftar Pendidikan Umum</b>");
                        }else if(Integer.parseInt(str)==15){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_diklat_fungsional.jsp\">");
                            out.println("&nbsp;<b>Daftar Diklat Fungsional</b>");
                        }else if(Integer.parseInt(str)==16){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_diklat_struktural.jsp\">");
                            out.println("&nbsp;<b>Daftar Diklat Struktural</b>");
                        }else if(Integer.parseInt(str)==17){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_diklat_teknis.jsp\">");
                            out.println("&nbsp;<b>Daftar Diklat Teknis</b>");
                        }else if(Integer.parseInt(str)==18){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_penataran.jsp\">");
                            out.println("&nbsp;<b>Daftar Penataran</b>");
                        }else if(Integer.parseInt(str)==19){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_seminar.jsp\">");
                            out.println("&nbsp;<b>Daftar Seminar PNS</b>");
                        }else if(Integer.parseInt(str)==20){
                            out.println("<form name=\"frmimportpns\" method=\"post\" action=\"import_kursus.jsp\">");
                            out.println("&nbsp;<b>Daftar Kursus PNS</b>");
                        }
						
						out.println("<table><tr><td>");
					    out.println("<table class=\"listborder\" cellpadding=\"1\" cellspacing=\"1\">");
					
					if(v!=null && v.size()>0){
						int maxV = v.size();
						// create header/title
						out.println("<tr>");
						for(int tit=0; tit<numcol; tit++){
							out.println("<td class=\"listheader\">"+v.elementAt(tit)+"</td>");
						}
						out.println("</tr>");
						// iterasi dilakukan mulai indeks ke (numcol) karena
                            // baris pertama dari schedule excel adalah JUDUL/TITLE
							
							System.out.println("maxV:::::::::::::::::::::::::::::::::::::::::"+maxV);
							
							
                            if(Integer.parseInt(str)==0){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[26];
									 // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nip)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 2 ==> pada kolom III (kabupaten)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gelar_dpn\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gelar_dpn\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 3 ==> pada kolom IV (propinsi)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gelar_blk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gelar_blk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 4 ==> pada kolom V (golongan darah)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 6 ==> pada kolom VII (golongan karpeg)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 6 : // kalo sisanya 7 ==> pada kolom VIII (no taspen)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_kelamin\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_kelamin\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 7 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"agama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"agama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 8 : // kalo sisanya 9 ==> pada kolom X (nama kk)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sts_peg\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sts_peg\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 9 : // kalo sisanya 9 ==> pada kolom X (nama kk)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_peg\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_peg\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 10 : // kalo sisanya 9 ==> pada kolom X (nama kk)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"keduk_peg\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"keduk_peg\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 11 : // kalo sisanya 9 ==> pada kolom X (nama kk)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sts_kawin\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sts_kawin\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 12 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angka_rt\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angka_rt\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 13 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angka_rw\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angka_rw\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 14 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 15 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 16 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 17 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 18 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 19 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 20 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gol_darah\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gol_darah\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 21 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gol_karpeg\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"gol_karpeg\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 22 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_taspen\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_taspen\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 23 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"npwp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"npwp\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 24 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_askes\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_askes\" value=\"\" >&nbsp;</td>");
											}
										break;
										case 25 : // kalo sisanya 9 ==> pada kolom X (nama kk)
											if(v.elementAt(i)!=null){
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_karis_karsu\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
											}else{
												out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"no_karis_karsu\" value=\"\" >&nbsp;</td>");
											}
											out.println("</tr>");
										break;
                                        default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                            break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }
                            // ini untuk harga jual barang
                            else if(Integer.parseInt(str)==1){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[8];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nota_bkn\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nota_bkn\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
                                            break;

                                        case 6 : // kalo sisanya 7 ==> pada kolom VIII (tempat lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 7 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_cpns\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_cpns\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                            break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==2){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[8];
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 6 ==> pada kolom VII (gol peserta)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pangkat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pangkat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 6 : // kalo sisanya 7 ==> pada kolom VIII (tempat lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 7 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_pns\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_pns\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 8 : // kalo sisanya 9 ==> pada kolom X (nama kk)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sumpah\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sumpah\" value=\"\" >&nbsp;</td>");
                                            }
                                            out.println("</tr>");
                                            break;
                                        default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                            break;

                                    }
                                   if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==3){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[13];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_lahir\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_lahir\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_lahir\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_lahir\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pekerjaan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pekerjaan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rt\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rt\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
                                            break;

                                        case 6 : // kalo sisanya 7 ==> pada kolom VIII (tempat lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rw\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rw\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 7 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 8 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 9 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 10 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 11 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 12 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                         break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==4){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[13];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_lahir\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_lahir\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_lahir\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_lahir\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pekerjaan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pekerjaan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rt\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rt\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
                                            break;

                                        case 6 : // kalo sisanya 7 ==> pada kolom VIII (tempat lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rw\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"alamat_rw\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 7 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"telp\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 8 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kode_pos\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 9 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"desa\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 10 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kecamatan\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 11 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kabupaten\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 12 : // kalo sisanya 8 ==> pada kolom IX (tanggal lahir)
                                            if(v.elementAt(i)!=null){
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"propinsi\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                         break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==5){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[6];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan_ruang\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"golongan_ruang\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_pangkat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_pangkat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pej_menetapkan\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 5 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==6){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[5];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"srt_kenaikan_gj\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"srt_kenaikan_gj\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_kenaikan_gj\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_kenaikan_gj\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sk_kenaikan_gj\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sk_kenaikan_gj\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_kenaikan_gj\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_kenaikan_gj\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==7){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[6];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"instansi_induk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"instansi_induk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"unit_kerja\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"unit_kerja\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_tmp_kerja\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_tmp_kerja\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==8){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[13];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pejabat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pejabat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sk_jabatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sk_jabatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sk\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_jabatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_jabatan\" value=\"\" >&nbsp;</td>");
                                            }
											break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_jabatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_jabatan\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_eselon\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_eselon\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sub_eselon\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"sub_eselon\" value=\"\" >&nbsp;</td>");
                                            }
										break;
									    case 9 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_jabatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmt_jabatan\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 10 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sk_lantik\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sk_lantik\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 11 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_lantik\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_lantik\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 12 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"smph_jabatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"smph_jabatan\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==9){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[5];
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_hukuman\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_hukuman\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pejabat_pemberi_pts\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"pejabat_pemberi_pts\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"keterangan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"keterangan\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
										break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==10){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[7];
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_organisasi\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jenis_organisasi\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_organisasi\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_organisasi\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kedudukan/jab\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kedudukan/jab\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_pimpinan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_pimpinan\" value=\"\" >&nbsp;</td>");
                                            }
											out.println("</tr>");
										break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==11){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[6];
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_tanda_jasa\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_tanda_jasa\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tahun\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tahun\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"asal_perolehan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"asal_perolehan\" value=\"\" >&nbsp;</td>");
                                            }
										out.println("</tr>");
										break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==12){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmpt_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmpt_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_kursus\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_kursus\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_kursus\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_piagam\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_piagam\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 9 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_piagam\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_piagam\" value=\"\" >&nbsp;</td>");
                                            }
										out.println("</tr>");
										break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==13){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[5];
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;

                                        case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_bhs_daerah\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_bhs_daerah\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;

                                        case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kemampuan_bic\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kemampuan_bic\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 3 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_bhs_asing\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_bhs_asing\" value=\"\" >&nbsp;</td>");
                                            }
										break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kemampuan_bic_asing\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"kemampuan_bic_asing\" value=\"\" >&nbsp;</td>");
                                            }
										out.println("</tr>");
										break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==14){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[8];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tingkat_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tingkat_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jurusan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jurusan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_sekolah\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_sekolah\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmpt_sekolah\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tmpt_sekolah\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_kepala_sekolah\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nm_kepala_sekolah\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sttb\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nomor_sttb\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 7 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sttb\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tanggal_sttb\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==15){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pend\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pend\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pnd\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pnd\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 7 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pend\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pend\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											break;
										case 8 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttpp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttpp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttpp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttpp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==16){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttp\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==17){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_diklat\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pndk\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_pndk\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttp\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_sttp\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_sttp\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;

                                    }
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==18){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_penataran\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_penataran\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_penataran\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_penataran\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_penataran\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_penataran\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_penataran\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_penataran\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_penataran\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_penataran\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==19){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_seminar\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_seminar\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_seminar\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_seminar\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_seminar\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_seminar\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_seminar\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_seminar\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_seminar\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_seminar\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }else if(Integer.parseInt(str)==20){
                                for(int i=numcol; i<maxV; i++){
                                    boolean stserror = false;
                                    String[] arrErrMessage = new String[10];
                                    //System.out.println("asdjflksdjflka;sdlkf");
                                    // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
                                    int it = i / numcol;
                                    switch ((i % numcol)){
                                        case 0 : // kalo sisanya 0 ==> pada kolom I (nomor peserta)
                                            if(v.elementAt(i)!=null){
                                                String w = v.elementAt(i).toString();
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<tr>");
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nip\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 1 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nama_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 2 : // kalo sisanya 1 ==> pada kolom II (nama)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                stserror = true;
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tempat_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										 case 3 : // kalo sisanya 2 ==> pada kolom III (ktp/NIK)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"penyelenggara\" value=\"\">&nbsp;</td>");
                                            }
                                            break;
										case 4 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"angkatan\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 5 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_mulai_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 6 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_selesai_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 7 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_kursus\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"jam_kursus\" value=\"\" >&nbsp;</td>");
                                            }
                                        break;
										case 8 : // kalo sisanya 3 ==> pada kolom IV (jns kelamin)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"" + v.elementAt(i) + "\" >"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"nmr_piagam\" value=\"\" >&nbsp;</td>");
                                            }
                                            break;
										case 9 : // kalo sisanya 4 ==> pada kolom V (siak)
                                            if(v.elementAt(i)!=null){
                                                String x = v.elementAt(i).toString();
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }else{
                                                out.println("<td class=\"listcell\"><input type=\"hidden\" name=\"tgl_piagam\" value=\"" + v.elementAt(i) + "\">"+v.elementAt(i)+"</td>");
                                            }
											out.println("</tr>");
                                            break;
										default :
                                            out.println("<td class=\"listcell\">" + v.elementAt(i) + "</td>");
                                        break;
									}
                                    if(stserror)
                                        vectErr.add(arrErrMessage);
                                }
                            }
						}

						out.println("</table>");
						out.println("</td></tr></table>");

						out.println("<table><tr><td>");
						out.println("<input type=\"submit\" value=\" Upload Data \">");
						out.println("</td></tr></table>");

						out.println("</form>");
						inStream.close();

					}catch (Exception e){
						System.out.println("---===Error : " + e.toString());
					}
										
					%>
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
