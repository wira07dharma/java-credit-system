<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<%@ page import="java.util.*,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.form.aktiva.*,
                 com.dimata.aiso.entity.aktiva.*,
                 com.dimata.aiso.session.report.SessWorkSheet,
                 com.dimata.aiso.session.aktiva.SessSellingAktiva,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.aiso.entity.masterdata.ModulAktiva,
                 com.dimata.util.Command,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.aiso.entity.masterdata.PstAktiva,
                 com.dimata.aiso.entity.masterdata.Aktiva,
                 com.dimata.util.Formater,
                 com.dimata.aiso.session.report.SessAktivaSusut,
                 com.dimata.aiso.entity.report.AktivaSusut" %>
<!--import aiso-->
<% int  appObjCode =  1; //AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition
//if(!privView && !privAdd && !privUpdate && !privDelete && !privSubmit){
%>
<!--
<script language="javascript">
	window.location="<%//=approot%>/nopriv.html";
</script>
-->
<!-- if of "has access" condition -->
<%
//}else{
%>
<%!
public static final int INT_VALID_DELETE = 0;
public static final int INT_INVALID_DELETE = 1;
String formatNumber = "#,###.00";

public static String strItemTitle[][] = {
	{
	"No","Kode","Nama","Tanggal Perolehan","Nilai Buku","Nilai Perolehan",
    "Mutasi","s.d Bulan Lalu","Penambahan","Pengurangan","s.d Bulan Ini","Penyusutan","Masa Manfaat"
	},

	{
	"No","Code","Name","Date Result","Book Value","Value Result",
    "Mutasi","Until Last Month","Increment","Decrement","Until this Month","Decrease","Masa Manfaat"
	}
};

public static String strTitle[][] =
{
	{
		"Periode",
		"Type Penyusutan",
		"Metode Penyusutan"
	},
	{
		"Periode",
		"Tipe Penyusutan",
		"Metode Penyusutan"
	}
};

    public static final String masterTitle[] = {
        "Laporan","Report"
    };

    public static final String listTitle[] = {
        "Laporan Penyusutan Aktiva","Depresiation Aktiva Report"
    };



/**
* this method used to list jurnal detail
*/
public Vector drawList(int language, int iCommand,Vector objectClass,long oidPeriod){
    Vector listall = new Vector();
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","2","0","center","right"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"8%","2","0","center","left"); // nama
    ctrlist.dataFormat(strItemTitle[language][2],"25%","2","0","center","left"); // kode
    ctrlist.dataFormat(strItemTitle[language][3],"8%","2","0","center","center"); // masa manfaat
    ctrlist.dataFormat(strItemTitle[language][12],"8%","2","0","center","center"); // harga

    ctrlist.dataFormat(strItemTitle[language][5],"8%","0","4","center","center"); // n
    ctrlist.dataFormat(strItemTitle[language][11],"8%","0","4","center","center"); // nuku
    ctrlist.dataFormat(strItemTitle[language][4],"8%","2","0","center","center"); // harga

    ctrlist.dataFormat(strItemTitle[language][7],"8%","0","0","center","center"); //
    ctrlist.dataFormat(strItemTitle[language][8],"8%","0","0","center","center"); // totga jual
    ctrlist.dataFormat(strItemTitle[language][9],"8%","0","0","center","center"); // tot
    ctrlist.dataFormat(strItemTitle[language][10],"8%","0","0","center","center"); //

    ctrlist.dataFormat(strItemTitle[language][7],"8%","0","0","center","center"); // tal
    ctrlist.dataFormat(strItemTitle[language][8],"8%","0","0","center","center"); // totl
    ctrlist.dataFormat(strItemTitle[language][9],"8%","0","0","center","center"); // totaual
    ctrlist.dataFormat(strItemTitle[language][10],"8%","0","0","center","center"); // tjual

    // header for report/print out
    Vector list_hd = new Vector();
    list_hd.add(strItemTitle[language][0]);
    list_hd.add(strItemTitle[language][1]);
    list_hd.add(strItemTitle[language][2]);
    list_hd.add(strItemTitle[language][3]);
    list_hd.add(strItemTitle[language][12]);

    list_hd.add(strItemTitle[language][5]);
    list_hd.add(strItemTitle[language][11]);
    list_hd.add(strItemTitle[language][4]);

    list_hd.add(strItemTitle[language][7]);
    list_hd.add(strItemTitle[language][8]);
    list_hd.add(strItemTitle[language][9]);
    list_hd.add(strItemTitle[language][10]);

    list_hd.add(strItemTitle[language][7]);
    list_hd.add(strItemTitle[language][8]);
    list_hd.add(strItemTitle[language][9]);
    list_hd.add(strItemTitle[language][10]);

	ctrlist.setLinkRow(-1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
    long preOidPeriod = SessWorkSheet.getOidPeriodeLalu(oidPeriod);

    Vector list_data = new Vector();
	for (int i = 0; i < objectClass.size(); i++) {
        AktivaSusut aktivaSusut = (AktivaSusut)objectClass.get(i);

		rowx = new Vector();
        //double totalPenyusutan = PstPenyusutanAktiva.getTotalNilaiSusut(aktivaSusut.getOID());
		rowx.add(""+(i+1));
		rowx.add(aktivaSusut.getKode());
        rowx.add(aktivaSusut.getNamaaktiva());
        rowx.add(Formater.formatDate(aktivaSusut.getTglPerolehan(),"dd-MM-yyyy"));
        rowx.add(""+aktivaSusut.getMasaManfaat()); // masa manfaat
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getMutasiProlehBulanLalu())+"</div>");// mutasi bulan lalu
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getMutasiTambah())+"</div>"); // tambah bln ini
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getMustasiKurang())+"</div>"); // kurang bln ini
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getTotalBulanIni())+"</div>"); // total bln ini
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutBulanlalu())+"</div>"); // sst bln lalu
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutTambah())+"</div>"); // sst tambah bln ini
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutKurang())+"</div>");
		rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getTotalSusutBulanIni())+"</div>");
        rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(aktivaSusut.getNilaiBuku())+"</div>");

		lstData.add(rowx);
		lstLinkData.add(String.valueOf(aktivaSusut.getNamaaktiva()));

        // for report/print out
        Vector list = new Vector();
        list.add(aktivaSusut.getKode());
        list.add(aktivaSusut.getNamaaktiva());
        list.add(Formater.formatDate(aktivaSusut.getTglPerolehan(),"dd-MM-yyyy"));
        list.add(""+aktivaSusut.getMasaManfaat());
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getMutasiProlehBulanLalu()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getMutasiTambah()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getMustasiKurang()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getTotalBulanIni()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutBulanlalu()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutTambah()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getSusutKurang()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getTotalSusutBulanIni()));
        list.add(FRMHandler.userFormatStringDecimal(aktivaSusut.getNilaiBuku()));
        list_data.add(list);
	 }

    listall.add(ctrlist.drawMeList());
    listall.add(list_hd);
    listall.add(list_data);

    return listall;
}

%>
<!-- JSP Block -->

<%
/** Get value from hidden form */
showMenu = true;
replaceMenuWith = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "COMPLETE PENYUSUTAN PROCESS BEFORE SWITCH TO ANOTHER" : "SELESAIKAN PROSES PENYUSUTAN SEBELUM MELAKUKAN PROSES LAIN";
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long periodeId = FRMQueryString.requestLong(request,"PERIODE");
long typePenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_TYPE_PENYUSUTAN");
long metodepenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_METODE_PENYUSUTAN");

/**
* Declare Commands caption
*/

if(iCommand==Command.NONE)
    iCommand = Command.ADD;

// untuk mencari aktiva sesuai dengan metode penyusutannya
Vector list = SessAktivaSusut.getReportAktivaAndPenyusutan(periodeId,typePenyusutanId,metodepenyusutanId,0,5); //,metodepenyusutanId

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdsearch(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";
	document.frmorderaktiva.submit();
}

function reportPdf(){
		var linkPage = "<%=reportroot%>report.aktiva.AktivaPenyusutanPdf";
		window.open(linkPage);
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="start" value="<%=start%>">
			  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="type_penyusutan_aktiva_id" value="<%=typePenyusutanId%>">
              <input type="hidden" name="metode_penyusutan_aktiva_id" value="<%=metodepenyusutanId%>">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgensell">
                <tr>
                  <td width="94%" height="25" class="listgensell" valign="top">&nbsp;</td>
                </tr>
                <tr>
                  <td width="94%" class="listgensell">
                    <table width="100%">
                      <tr>
                        <td width="15%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25">                  <%
                            String period_name = "";
                      Vector vtPeriod = PstPeriode.list(0,0,"","");
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode prd = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+prd.getOID());
                        vPeriodVal.add(prd.getNama());

                          if(periodeId==prd.getOID())
                            period_name = prd.getNama().toUpperCase();

                      }
                      out.println(ControlCombo.draw("PERIODE","","",""+periodeId,vPeriodKey,vPeriodVal,""));
				  %></td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][1]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25">
                          <%
                              String name_aktiva_type = "";
                          Vector vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          Vector vAktivaKey = new Vector(1,1);
                          Vector vAktivaVal = new Vector(1,1);
                          vAktivaKey.add("0");
                          vAktivaVal.add("Pilih...");
                          for(int k=0;k < vtAktiva.size();k++){
                              Aktiva aktiva = (Aktiva)vtAktiva.get(k);
                              vAktivaKey.add(""+aktiva.getOID());
                              vAktivaVal.add(aktiva.getNama());

                              if(typePenyusutanId==aktiva.getOID())
                                name_aktiva_type = aktiva.getNama().toUpperCase();

                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_TYPE_PENYUSUTAN","",null,""+typePenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25"><%
                            String name_aktiva_metode = "";
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add("Pilih...");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());

                              if(metodepenyusutanId==aktiva.getOID())
                                name_aktiva_metode = aktiva.getNama().toUpperCase();
                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_METODE_PENYUSUTAN","",null,""+metodepenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;</td>
                        <td width="1%" height="25">&nbsp;</td>
                        <td width="84%" height="25">&nbsp;<a href="javascript:cmdsearch()"><b>Tampilkan</b></a></td>
                      </tr>
                      <tr>
                        <td colspan="3"> </td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="3"><%
                            Vector listall = drawList(SESS_LANGUAGE,iCommand,list,currentPeriodOid);
                            out.println(listall.get(0));

                            // session for report
                            Vector listreport = new Vector();
                            Vector list_param = new Vector();
                            list_param.add(listTitle[SESS_LANGUAGE].toUpperCase());
                            list_param.add(period_name);
                            list_param.add(name_aktiva_type);
                            list_param.add(name_aktiva_metode);
                            listreport.add(list_param);
                            listreport.add(listall.get(1));
                            listreport.add(listall.get(2));
                            session.putValue("aktiva_dan_penyusutannya",listreport);
                        %></td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;<a href="javascript:reportPdf()"><b>Cetak Laporan</b></a></td>
                      </tr>
                      <tr>
                        <td width="15%" valign="top" height="25"></td>
                        <td width="1%" height="25">&nbsp;</td>
                        <td width="84%" height="25">&nbsp;&nbsp;</td>
                      </tr>
                  </table></td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td height="100%"> 
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%//}%>
