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
                 com.dimata.aiso.entity.masterdata.*,
                 com.dimata.util.Command,
                 com.dimata.gui.jsp.ControlCombo,
		 com.dimata.gui.jsp.*,
		 com.dimata.aiso.entity.report.*,
                 com.dimata.util.Formater,
                 com.dimata.aiso.session.report.SessAktivaSusut,
                 com.dimata.aiso.entity.report.AktivaSusut" %>
<!--import aiso-->
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
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
	    "Mutasi","s.d Bulan Lalu","Penambahan","Pengurangan","s.d Bulan Ini","Penyusutan","Masa Manfaat",
	    "Lokasi","Qty"
	},

	{
	    "No","Code","Name","Acquisition Date","Book Value","Acquisition Value",
	    "Movement","Until Last Month","Increment","Decrement","Until this Month","Depreciation","Life",
	    "Location","Qty"
	}
};

public static String strTitle[][] =
{
	{
		"Periode",
		"Type Penyusutan",
		"Metode Penyusutan",
		"Kelompok Aktiva",
		"Perkiraan Aktiva",
		"Lokasi Inventaris"
	},
	{
		"Period",
		"Depreciation Type",
		"Depreciation Method",
		"Fixed Assets Group",
		"Fixed Assets Account",
		"Fixed Assets Location"
	}
};

    public static final String masterTitle[] = {
        "Laporan","Report"
    };

    public static final String listTitle[] = {
        "Daftar Aktiva","Fixed Assets List"
    };


public Vector drawListFA(int language, int iCommand,Vector objectClass,long oidPeriod, int start, Vector countTotal){
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
	ctrlist.dataFormat(strItemTitle[language][13],"25%","2","0","center","left"); // Location
	ctrlist.dataFormat(strItemTitle[language][3],"8%","2","0","center","center"); // masa manfaat	
	ctrlist.dataFormat(strItemTitle[language][12],"8%","2","0","center","center"); // harga
	ctrlist.dataFormat(strItemTitle[language][14],"8%","2","0","center","center"); // qty
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
	list_hd.add(strItemTitle[language][0]);//0.No
	list_hd.add(strItemTitle[language][1]);//1.Kode
	list_hd.add(strItemTitle[language][2]);//2.Nama
	list_hd.add(strItemTitle[language][13]);//3.Lokasi
	list_hd.add(strItemTitle[language][3]);//4.Tanggal Perolehan
	list_hd.add(strItemTitle[language][12]);//5.Masa Manfaat	
	list_hd.add(strItemTitle[language][14]);//6.Qty
	list_hd.add(strItemTitle[language][5]);//7.Nilai Perolehan
	list_hd.add(strItemTitle[language][11]);//8.Penyusutan
	list_hd.add(strItemTitle[language][4]);//9.Nilai Buku
	list_hd.add(strItemTitle[language][7]);//10.s.d Bulan Lalu
	list_hd.add(strItemTitle[language][8]);//11.Penambahan
	list_hd.add(strItemTitle[language][9]);//12.Pengurangan
	list_hd.add(strItemTitle[language][10]);//13.s.d Bulan Ini
	list_hd.add(strItemTitle[language][7]);//14.s.d Bulan Lalu
	list_hd.add(strItemTitle[language][8]);//15.Penambahan
	list_hd.add(strItemTitle[language][9]);//16.Pengurangan
	list_hd.add(strItemTitle[language][10]);//17.s.d Bulan Ini

	ctrlist.setLinkRow(-1);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	ctrlist.reset();
	Vector rowx = new Vector(1,1);	
	
	double tPerolehanBulanLalu = 0;
	double tMutasiTambah = 0;
	double tMutasiKurang = 0;
	double tTotalBulanIni = 0;
	double tSusutBulanlalu = 0;
	double tSusutTambah = 0;
	double tSusutKurang = 0;
	double tTotalSusutBulanIni = 0;
	double tNilaiBuku = 0;
	double susutBulanIni = 0;
	double nilaiBuku = 0;
	int iQty = 0;
	
	try{
	    for (int i = 0; i < objectClass.size(); i++) {
		    ReportFixedAssets objReportFA = (ReportFixedAssets)objectClass.get(i);	 	
		    rowx = new Vector();

		    rowx.add(""+(start));
		    rowx.add(objReportFA.getCode());
		    rowx.add(objReportFA.getName());
		    rowx.add(objReportFA.getLocation());
		    rowx.add(Formater.formatDate(objReportFA.getAqcDate(),"dd-MM-yyyy"));	  
		    rowx.add(""+objReportFA.getLife()); // masa manfaat
		    rowx.add("<div align=\"right\">"+objReportFA.getQty()+"</div>"); // qty
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getAqcLastMonth())+"</div>");// mutasi bulan lalu
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getAqcIncrement())+"</div>"); // tambah bln ini
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getAqcDecrement())+"</div>"); // kurang bln ini       
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getAqcThisMonth())+"</div>"); // total bln ini
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getDepLastMonth())+"</div>"); // sst bln lalu
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getDepIncrement())+"</div>"); // sst tambah bln ini
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getDepDecrement())+"</div>");
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getDepThisMonth())+"</div>");
		    rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objReportFA.getBookValue())+"</div>");		

		    tPerolehanBulanLalu = tPerolehanBulanLalu + objReportFA.getAqcLastMonth();
		    tMutasiTambah = tMutasiTambah + objReportFA.getAqcIncrement();
		    tMutasiKurang = tMutasiKurang + objReportFA.getAqcDecrement();
		    tTotalBulanIni = tTotalBulanIni + objReportFA.getAqcThisMonth();
		    tSusutBulanlalu = tSusutBulanlalu + objReportFA.getDepLastMonth();
		    tSusutTambah = tSusutTambah + objReportFA.getDepIncrement();
		    tSusutKurang = tSusutKurang + objReportFA.getDepDecrement();
		    tTotalSusutBulanIni = tTotalSusutBulanIni + objReportFA.getDepThisMonth();
		    tNilaiBuku = tNilaiBuku + objReportFA.getBookValue();
		    iQty += objReportFA.getQty();

		    lstData.add(rowx);


		    if(objReportFA.getDepThisMonth() == 0){
			    susutBulanIni = objReportFA.getDepLastMonth() + objReportFA.getDepIncrement() - objReportFA.getDepDecrement();
			    nilaiBuku = objReportFA.getAqcLastMonth() - susutBulanIni;
		    }else{
			    susutBulanIni = objReportFA.getDepThisMonth();
			    nilaiBuku = objReportFA.getBookValue();
		    }

		    start++;
	     }

	    rowx = new Vector();
	    rowx.add("");
	    rowx.add("");
	    rowx.add("");
	    rowx.add("");
	    rowx.add("<b><div align=\"center\">"+"SUB TOTAL"+"</b></div>");
	    rowx.add("");
	    rowx.add("<b><div align=\"right\">"+iQty+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tPerolehanBulanLalu)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tMutasiTambah)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tMutasiKurang)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tTotalBulanIni)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tSusutBulanlalu)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tSusutTambah)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tSusutKurang)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tTotalSusutBulanIni)+"</b></div>");
	    rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(tNilaiBuku)+"</b></div>");
	    lstData.add(rowx);	

	    if(countTotal.size() > 0){
		ReportFixedAssets objRptFA = (ReportFixedAssets) countTotal.get(0);
		rowx = new Vector();	
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<b><div align=\"center\">"+"TOTAL"+"</b></div>");
		rowx.add("");
		rowx.add("<b><div align=\"right\">"+objRptFA.getQty()+"</div></b>");
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getAqcLastMonth())+"</div></b>");// mutasi bulan lalu
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getAqcIncrement())+"</div></b>"); // tambah bln ini
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getAqcDecrement())+"</div></b>"); // kurang bln ini
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getAqcThisMonth())+"</div></b>"); // total bln ini
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getDepLastMonth())+"</div></b>"); // sst bln lalu
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getDepIncrement())+"</div></b>"); // sst tambah bln ini
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getDepDecrement())+"</div></b>");
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getDepThisMonth())+"</div></b>");
		rowx.add("<b><div align=\"right\">"+FRMHandler.userFormatStringDecimal(objRptFA.getBookValue())+"</div></b>");

		lstData.add(rowx);
	    }
	    listall.add(ctrlist.drawMeList());
	    listall.add(list_hd);
	}catch(Exception e){System.out.println("Exception on drawList :::: "+e.toString());}
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
long aktivaGroupId = FRMQueryString.requestLong(request,"GROUP_AKTIVA");
long perkAktivaId = FRMQueryString.requestLong(request,"PERK_AKTIVA");
long typePenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_TYPE_PENYUSUTAN");
long lLocationId = FRMQueryString.requestLong(request,"location");
int listCommand = FRMQueryString.requestInt(request, "command");
if(listCommand==Command.NONE) listCommand = Command.LIST;
long metodepenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_METODE_PENYUSUTAN");
String strViewReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ?"View Report" : "Tampilkan";
String strPrintReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ?"Print Report" : "Cetak Laporan";
String strAll = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ?"All" : "Semua";
//Declaration Variabel
int recordToGet = 100;



/**
* Declare Commands caption
*/

if(iCommand==Command.NONE)
    iCommand = Command.ADD;

Vector allList = new Vector(1,1);
int vectSize = 0;
if(iCommand != Command.ADD){
	vectSize = PstReportFixedAssets.getTotalRecord(periodeId,typePenyusutanId,metodepenyusutanId, aktivaGroupId,perkAktivaId,lLocationId);
	allList = PstReportFixedAssets.reportFixedAssets(periodeId,typePenyusutanId,metodepenyusutanId, aktivaGroupId,perkAktivaId,lLocationId,0,0,"");  
}

Vector countTotal = new Vector();

if(periodeId > 0){
countTotal.add(PstReportFixedAssets.getTotalValue(periodeId,typePenyusutanId,metodepenyusutanId, aktivaGroupId, perkAktivaId, lLocationId));
}
CtrlOrderAktiva controlOrderAktiva = new CtrlOrderAktiva(request);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = controlOrderAktiva.actionList(iCommand, start, vectSize, recordToGet);
 } 

// untuk mencari aktiva sesuai dengan metode penyusutannya
// Setup controlLine and Commands caption
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

Vector list = new Vector(1,1);
String strOrderBy = PstReportFixedAssets.fieldNames[PstReportFixedAssets.FLD_AQC_DATE];
if(iCommand == Command.LIST || (iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
	list = PstReportFixedAssets.reportFixedAssets(periodeId,typePenyusutanId,metodepenyusutanId, aktivaGroupId, perkAktivaId, lLocationId, start,recordToGet,strOrderBy);
}
String period_name = "";
String name_aktiva_type = "";
String name_aktiva_metode = "";
String group_aktiva = "";
String perk_aktiva = "";
String strLocation = "";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdsearch(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.LIST)%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";	
	document.frmorderaktiva.submit();
}

function cmdopen(){
	url = "location_list.jsp?command=<%=String.valueOf(Command.LIST)%>&"+							
		  "name="+document.frmorderaktiva.location_text.value;
		  
	window.open(url,"src_fixed_assets_loc_rpt","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function cmdEnter(){
	if(event.keyCode == 13){
		cmdopen();
	}
}

function reportPdf(){
		var linkPage = "<%=reportroot%>report.aktiva.AktivaPenyusutanPdf";
		window.open(linkPage);
}
function first(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.FIRST)%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";
	document.frmorderaktiva.submit();
}
function prev(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.PREV)%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";
	document.frmorderaktiva.submit();
}

function next(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.NEXT)%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";
	document.frmorderaktiva.submit();
}
function last(){
	document.frmorderaktiva.command.value="<%=String.valueOf(Command.LAST)%>";
	document.frmorderaktiva.action="aktiva_dan_penyusutannya.jsp";
	document.frmorderaktiva.submit();
}

function hideSearch(){
	document.getElementById("search").style.display = "none";
	document.getElementById("view").style.display = "";
	document.getElementById("hide").style.display = "none";
}

function viewSearch(){
	<%if(iCommand != Command.ADD){%>
	document.getElementById("search").style.display = "";
	document.getElementById("view").style.display = "none";
	document.getElementById("hide").style.display = "";
	<%}%>
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
            : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmorderaktiva" method="post" action="">
              <input type="hidden" name="command" value="<%=String.valueOf(iCommand)%>">
              <input type="hidden" name="start" value="<%=String.valueOf(start)%>">
	      <input type="hidden" name="prev_command" value="<%=String.valueOf(prevCommand)%>">
              <input type="hidden" name="type_penyusutan_aktiva_id" value="<%=String.valueOf(typePenyusutanId)%>">
              <input type="hidden" name="metode_penyusutan_aktiva_id" value="<%=String.valueOf(metodepenyusutanId)%>">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgensell">               
                <tr>
                  <td width="94%" class="listgensell">
                    <table width="100%">
                      <tr>
                        <td>
			    <table width="100%" id="search">
				    <tr>
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">                  
					<%                            
					      String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE]+" DESC ";
					      Vector vtPeriod = PstPeriode.list(0,0,"",orderBy);
					      Vector vPeriodKey = new Vector(1,1);
					      Vector vPeriodVal = new Vector(1,1);
					      for(int k=0;k<vtPeriod.size();k++){
						Periode prd = (Periode)vtPeriod.get(k);
						vPeriodKey.add(""+prd.getOID());
						vPeriodVal.add(prd.getNama());

						if(periodeId==prd.getOID())
						  period_name = prd.getNama().toUpperCase();

					      }
					      out.println(ControlCombo.draw("PERIODE","",null,""+periodeId,vPeriodKey,vPeriodVal,""));
					  %>
					</td>
				  </tr>
				  <tr>
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][1]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
					  <%                              
					      Vector vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
								"="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
					      Vector vAktivaKey = new Vector(1,1);
					      Vector vAktivaVal = new Vector(1,1);
					      vAktivaKey.add("0");
					      vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][1]);
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
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
					    <%                            
						  vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
							     "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
						  vAktivaKey = new Vector(1,1);
						  vAktivaVal = new Vector(1,1);
						  vAktivaKey.add("0");
						  vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][2]);
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
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][3]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
					    <%                            
						  Vector vtGroupAktiva = PstAktivaGroup.list(0,0,"",PstAktivaGroup.fieldNames[PstAktivaGroup.FLD_NAME]);
						  Vector vGroupAktivaKey = new Vector(1,1);
						  Vector vGroupAktivaVal = new Vector(1,1);
						  vGroupAktivaKey.add("0");
						  vGroupAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][3]);
						  for(int k=0;k < vtGroupAktiva.size();k++){
							AktivaGroup aktivaGroup = (AktivaGroup)vtGroupAktiva.get(k);

							vGroupAktivaKey.add(""+aktivaGroup.getOID());
							vGroupAktivaVal.add(aktivaGroup.getNama());

						        if(aktivaGroupId==aktivaGroup.getOID())
							group_aktiva = aktivaGroup.getNama().toUpperCase();
						  }
						  out.println(ControlCombo.draw("GROUP_AKTIVA","",null,""+aktivaGroupId,vGroupAktivaKey,vGroupAktivaVal,""));
					      %>
					</td>
				  </tr>
				  <%if(iFixedAssetsModule == 1){%>  
				  <tr>
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
						<input name="location" type="hidden" value="<%=String.valueOf(lLocationId)%>">
						<input name="location_text" type="text" value="<%=strLocation%>">
						<a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
					</td>
				  </tr>
				  <%}else{%>
				  <tr>
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][4]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
					    <%
						  Vector vtPerkAktiva = PstAccountLink.getVectObjListAccountLink(0,PstPerkiraan.ACC_GROUP_FIXED_ASSETS);                          
						  Vector vPerkAktivaKey = new Vector(1,1);
						  Vector vPerkAktivaVal = new Vector(1,1);
						  vPerkAktivaKey.add("0");
						  vPerkAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][4]);
						  for(int k=0;k < vtPerkAktiva.size();k++){
							Perkiraan perkiraan = (Perkiraan)vtPerkAktiva.get(k);

							vPerkAktivaKey.add(""+perkiraan.getOID());
							vPerkAktivaVal.add(perkiraan.getNama());

						        if(perkAktivaId==perkiraan.getOID())
							    perk_aktiva = perkiraan.getNama().toUpperCase();
						  }
						  out.println(ControlCombo.draw("PERK_AKTIVA","",null,""+perkAktivaId,vPerkAktivaKey,vPerkAktivaVal,""));
				          %>
					</td>
				  </tr>
				  <tr>
					<td width="15%" height="25" nowrap>&nbsp;<%=strTitle[SESS_LANGUAGE][5]%> </td>
					<td width="1%" height="25"><b>:</b></td>
					<td width="84%" height="25">
						<input name="location" type="hidden" value="<%=String.valueOf(lLocationId)%>">
						<input name="location_text" type="text" value="<%=strLocation%>">
						<a href="javascript:cmdopen()"><img border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
					</td>
				  </tr>
				  <%}%>
				  <tr>
					<td width="15%" height="25">&nbsp;</td>
					<td width="1%" height="25">&nbsp;</td>
					<td width="84%" height="25">&nbsp;
						<input name="viewButton" type="button" onClick="javascript:cmdsearch()" value="<%=strViewReport%>">
					</td>
				    </tr>
				</table>
			    </td>
                      </tr>
		      <%if(iCommand != Command.ADD){%>
		      <tr>
			    <td colspan="3" id="view">
				    <input name="viewcb" type="checkbox" onClick="javascript:viewSearch()" value="0"> View Search 
			    </td>
			    <td colspan="3" id="hide">
				    <input name="hidecb" type="checkbox" onClick="javascript:hideSearch()" value="1"> Hide Search 
			    </td>
		      </tr>
		      <%}%>
                      <tr>
			    <td colspan="3">
				<%				    	
				   
				    Vector listall = drawListFA(SESS_LANGUAGE,iCommand,list,currentPeriodOid,start+1,countTotal);		   
				    if(list != null && list.size() > 0){
					    out.println(listall.get(0));
				    }
				
                            
				   // session for report                           
				    Vector listreport = new Vector();
				    Vector list_param = new Vector();
				    list_param.add(listTitle[SESS_LANGUAGE].toUpperCase());
				    list_param.add(period_name);
				    list_param.add(name_aktiva_type);
				    list_param.add(name_aktiva_metode);
				    list_param.add(group_aktiva);
				    list_param.add(perk_aktiva);
				    list_param.add(""+SESS_LANGUAGE);
				    list_param.add(""+iFixedAssetsModule);
				    listreport.add(list_param);
				    listreport.add(listall.get(1));
				    listreport.add(allList);
				    if(countTotal.size() > 0 ){	
				    listreport.add(countTotal.get(0));}	
				    
				    session.putValue("aktiva_dan_penyusutannya",listreport);
				%>
			    </td>
                      </tr>
                      <!-- --------------------- Update by DWI ------------------------- -->
		      <tr>
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr> 
				      <td colspan="2"> 
					<%						
						if(list != null && list.size() > 0){
					%>                
				<tr> 
					  <%
					  	ctrLine.initDefault(SESS_LANGUAGE,"");
					  %>
					<td colspan="3" class="command"> <%=ctrLine.drawMeListLimit(iCommand, vectSize, start, recordToGet,"first","prev","next","last","left")%>  </td>
				</tr>                    
					<%}else{%>
				<tr> 
					<td colspan="3" >&nbsp;</td>
				</tr>
					<%}%>
                      <!-- ----------------------- End Update -------------------------------- -->
				<tr><td>&nbsp;</td></tr>
				<tr>
				    <td colspan="3">&nbsp;
					<%if(list != null && list.size() > 0){%>
						<input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strPrintReport%>">
					<%}%>
				    </td>
				  </tr>
				  <tr>
					<td width="15%" valign="top" height="25"></td>
					<td width="1%" height="25">&nbsp;</td>
					<td width="84%" height="25">&nbsp;&nbsp;</td>
				  </tr>
			  </table>
		      </table>
		    </form>
			<script language="JavaScript">
				<%if(iCommand == Command.ADD){%>
					viewSearch();
				<%}else{%>
					hideSearch();
				<%}%>
			</script>
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
