<%@ page import = "java.util.*"%>
<%@ page import = "com.dimata.util.*" %>
<%!
 final static int MODUS_AISO_DEFAULT=0;
 final static int MODUS_AISO_TRAVEL=1;

 static int MODUS_VIEW = MODUS_AISO_DEFAULT;

//jika modus view aiso adalah travel, silahkan modus view di ubah menjadi AISO_TRAVEL
%>
<%

String val = request.getParameter("user_group");
Date objDate = new Date();
long lTime = session.getLastAccessedTime();
int groupUser = Integer.parseInt(val);
/**
* pemilihan menu per user group.
* 0 = Admin
* 1 = Accounting Denpasar
* 2 = Accounting Bajo
* 3 = Staf Denpasar
* 4 = Staf Bajo
* 5 = Kasir Denpasar
* 6 = Kasir bajo
*/
	%>
	<script type="text/javascript">
	
	</script>
	<script type="text/javascript">
	<!--
	d = new dTree('d');
	
	d.config.target="";//"dtree";		
	d.add(0,-1,'<%=strMenuNames[SESS_LANGUAGE][0]%>',"javascript: d.oAll('true')");
	
	d.add(1,0,'<%=strMenuNames[SESS_LANGUAGE][1]%>',"javascript:setMainFrameUrl('<%=approot%>/homexframe.jsp')");

        
       //-------------------------------------------------------------- Menu Koperasi Update Hadi-------------------------------------------
       <% switch(groupUser){
                case 0 :%>//admin
                        d.add(1200, 0, '<%=strMenuNames[SESS_LANGUAGE][111]%>', 'javascript: d.0(111)');
                        d.add(1201,1200,'<%=strMenuNames[SESS_LANGUAGE][114]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/anggota_search.jsp')");
			d.add(1202,1200,'<%=strMenuNames[SESS_LANGUAGE][115]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/education.jsp')");
                        d.add(1203,1200,'<%=strMenuNames[SESS_LANGUAGE][116]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/kelompok_koperasi.jsp')");
                        d.add(1204,1200,'<%=strMenuNames[SESS_LANGUAGE][117]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/region/province.jsp')");
                        d.add(1205,1200,'<%=strMenuNames[SESS_LANGUAGE][118]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/region/city.jsp')");
                        d.add(1206,1200,'<%=strMenuNames[SESS_LANGUAGE][119]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/region/regency.jsp')");
                        d.add(1207,1200,'<%=strMenuNames[SESS_LANGUAGE][120]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/region/subregency.jsp')");
                        d.add(1208,1200,'<%=strMenuNames[SESS_LANGUAGE][121]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/region/ward.jsp')");
                        d.add(1209,1200,'<%=strMenuNames[SESS_LANGUAGE][122]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/vocation.jsp')");
                        d.add(1210,1200,'<%=strMenuNames[SESS_LANGUAGE][123]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/anggota/position.jsp')");
                         <% break;
               
       }%>
       
       //---------menu jenis tabungan
       <% switch(groupUser){
                case 0 :%>//admin
                        d.add(1260, 0, '<%=strMenuNames[SESS_LANGUAGE][113]%>', 'javascript: d.0(113)');
                        d.add(1261,1260,'<%=strMenuNames[SESS_LANGUAGE][124]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/jenis_deposito.jsp')");
                        d.add(1263,1260,'<%=strMenuNames[SESS_LANGUAGE][126]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/jenis_simpanan.jsp')");
                        d.add(1264,1260,'<%=strMenuNames[SESS_LANGUAGE][129]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/mastertabungan.jsp')");
                        d.add(1265,1260,'<%=strMenuNames[SESS_LANGUAGE][130]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/afiliasi.jsp')");
                        d.add(1266,1260,'<%=strMenuNames[SESS_LANGUAGE][131]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/setting_tabungan.jsp')");
                        d.add(1267,1260,'<%=strMenuNames[SESS_LANGUAGE][132]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/mastertabungan/type_tabungan.jsp')");
                        
                        <% break;
               
      }%>
       //---------------------menu Transaksi Koperasi
       <% switch(groupUser){
                case 0 :%>//admin
                        d.add(1250, 0, '<%=strMenuNames[SESS_LANGUAGE][112]%>', 'javascript: d.0(112)');
                        d.add(1251,1250,'<%=strMenuNames[SESS_LANGUAGE][127]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/deposito.jsp')");
                        d.add(1252,1250,'<%=strMenuNames[SESS_LANGUAGE][128]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/listpinjaman.jsp')");
                        d.add(1253,1250,'<%=strMenuNames[SESS_LANGUAGE][133]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/data_tabungan.jsp')");
                        d.add(1254,1250,'<%=strMenuNames[SESS_LANGUAGE][134]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/data_transaksi.jsp')");
                         <% break;
               
       }%>
         
      d.add(1270, 0, '<%=strMenuNames[SESS_LANGUAGE][135]%>', 'javascript: d.0(116)');
      d.add(1271,1270,'<%=strMenuNames[SESS_LANGUAGE][136]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/masterreportsp/report_tabungan.jsp')");
      d.add(1272,1270,'<%=strMenuNames[SESS_LANGUAGE][137]%>',"#");
      //end Menu Koperasi
      d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/Manual Aiso_Ina.htm')");
      d.add(1150,0,'<%=strMenuNames[SESS_LANGUAGE][32]%>',"javascript:logOut('<%=approot%>/logout.jsp')");
      //d.add(1151,0,'<%=strMenuNames[SESS_LANGUAGE][119]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/transaksi/deposito.jsp')");
      document.write(d);
      d.closeAll();

//-->
</script>
