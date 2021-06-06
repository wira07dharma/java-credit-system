<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import java-->
<%@ page import="java.util.*,
                 com.dimata.interfaces.trantype.I_TransactionType,
                 com.dimata.common.entity.contact.ContactList,
                 com.dimata.common.entity.contact.PstContactList,
                 com.dimata.aiso.form.aktiva.*,
                 com.dimata.aiso.entity.aktiva.*,
                 com.dimata.aiso.session.report.SessWorkSheet" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.util.*" %>

<!--import qdep-->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.qdep.entity.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<!--import common-->
<%@ page import="com.dimata.common.entity.payment.*" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.periode.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/** Check privilege except VIEW, view is already checked on checkuser.jsp as basic access */
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

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
	"No","Kode","Nama","Masa Manfaat","Nilai Perolehan","Nilai Residu","Penyusutan"
	},

	{
	"No","Code","Name","Masa Manfaat","Nilai Perolehan","Nilai Residu","Penyusutan"
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
        "Penyusutan Aktiva","Penyusutan Aktiva"
    };

    public static final String listTitle[] = {
        "Proses Penyusutan","Penyusutan Process"
    };



/**
* this method used to list jurnal detail
*/
public String drawList(int language, int iCommand,Vector objectClass,long oidPeriod){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strItemTitle[language][0],"3%","left","left"); // no
    ctrlist.dataFormat(strItemTitle[language][1],"8%","left","left"); // kode
    ctrlist.dataFormat(strItemTitle[language][2],"25%","left","left"); // nama
    ctrlist.dataFormat(strItemTitle[language][3],"8%","left","left"); // qty
    ctrlist.dataFormat(strItemTitle[language][4],"8%","left","left"); // harga
    ctrlist.dataFormat(strItemTitle[language][5],"8%","left","left"); // total harga
	ctrlist.dataFormat(strItemTitle[language][6],"8%","left","left"); // total harga

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
	for (int i = 0; i < objectClass.size(); i++) {
		ModulAktiva modulAktiva = (ModulAktiva)objectClass.get(i);

		rowx = new Vector();
		rowx.add(""+(i+1));
		rowx.add(modulAktiva.getKode());
		rowx.add(modulAktiva.getName());
		rowx.add("<div align=\"center\">"+modulAktiva.getMasaManfaat()+"</div>");
		rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getHargaPerolehan())+"</div>");
		rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getNilaiResidu())+"</div>");

        Aktiva aktiva = new Aktiva();
        try{
            aktiva = PstAktiva.fetchExc(modulAktiva.getMetodePenyusutanOid());
        }catch(Exception e){}
        double nilaiPenyu = 0.0;
        Date dateNow = new Date();
        switch(aktiva.getTypeMetodePenyusutan()){
            case PstAktiva.METODE_PENYUSUTAN_GARIS_LURUS:
                nilaiPenyu = ((modulAktiva.getHargaPerolehan() - modulAktiva.getNilaiResidu()) / modulAktiva.getMasaManfaat()) / 12;
                if(modulAktiva.getTglPerolehan()!=null){
                    Date bts = modulAktiva.getTglPerolehan();
                    bts.setYear(bts.getYear()+modulAktiva.getMasaManfaat() + 1);
                    if(dateNow.after(bts)){
                            nilaiPenyu = 0;
                    }
                }
                break;
            case PstAktiva.METODE_PENYUSUTAN_SALDO_MENURUN:
                /**
                 * mencari penyusutan periode lalu
                 */
                String where = PstPenyusutanAktiva.fieldNames[PstPenyusutanAktiva.FLD_PERIODE_ID]+"="+preOidPeriod+
                        " AND "+PstPenyusutanAktiva.fieldNames[PstPenyusutanAktiva.FLD_AKTIVA_ID]+"="+modulAktiva.getOID();
                Vector vect = PstPenyusutanAktiva.list(0,0,where,"");
                PenyusutanAktiva penyusutanAktiva = new PenyusutanAktiva();
                if(vect!=null && vect.size()>0){
                    penyusutanAktiva = (PenyusutanAktiva)vect.get(0);
                }
                nilaiPenyu = ((modulAktiva.getHargaPerolehan() - penyusutanAktiva.getValue_pny()) * modulAktiva.getPersenPenyusutan() / 100) / 12;
                if(modulAktiva.getTglPerolehan()!=null){
                    Date btss = modulAktiva.getTglPerolehan();
                    btss.setYear(btss.getYear()+modulAktiva.getMasaManfaat());
                    if(dateNow.after(btss)){
                        double totalSusut = PstPenyusutanAktiva.getTotalNilaiSusut(modulAktiva.getOID());
                        nilaiPenyu = modulAktiva.getHargaPerolehan() - totalSusut;
                    }
                }
                break;
        }
		rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(nilaiPenyu)+"</div>");

		lstData.add(rowx);
		lstLinkData.add(String.valueOf(modulAktiva.getOID()));
	 }
	 return ctrlist.drawMe(-1);
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
long typePenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_TYPE_PENYUSUTAN");
long metodepenyusutanId = FRMQueryString.requestLong(request,"TYPE_AKTIVA_METODE_PENYUSUTAN");

/**
* Declare Commands caption
*/
String strAdd = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Add New Detail" : "Tambah Detail";
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSave = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Save Detail" : "Simpan Detail";
String strDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Delete Detail" : "Hapus Detail";
String strYesDelete = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes Delete Detail" : "Ya Hapus Detail";
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";

    if(iCommand==Command.NONE)
        iCommand = Command.ADD;

    // untuk mencari aktiva sesuai dengan metode penyusutannya
String whereClause = "";
    if(typePenyusutanId!=0){
        whereClause = PstModulAktiva.fieldNames[PstModulAktiva.FLD_TYPE_PENYUSUTAN_ID]+"="+typePenyusutanId;
    }
    if(metodepenyusutanId!=0){
        if(whereClause.length()>0)
            whereClause = whereClause + " AND " + PstModulAktiva.fieldNames[PstModulAktiva.FLD_METODE_PENYUSUTAN_ID]+"="+metodepenyusutanId;
        else
            whereClause = PstModulAktiva.fieldNames[PstModulAktiva.FLD_METODE_PENYUSUTAN_ID]+"="+metodepenyusutanId;
    }
Vector list = PstModulAktiva.list(0,0,whereClause,""); //,metodepenyusutanId

    // untuk mencari metode penyusutan yang di terapkan
    // int metodePenyusutan = PstAktiva.METODE_PENYUSUTAN_GARIS_LURUS;

    // untuk mencari object periode
Periode periode = new Periode();
try{
    periode = PstPeriode.fetchExc(currentPeriodOid);
}catch(Exception e){}

// Instansiasi CtrlJurnalDetail and FrmJurnalDetail
CtrlPenyusutanAktiva ctrlPenyusutanAktiva = new CtrlPenyusutanAktiva(request);
ctrlPenyusutanAktiva.setLanguage(SESS_LANGUAGE);
FrmPenyusutanAktiva frmOrderAktivaItem = ctrlPenyusutanAktiva.getForm();
PenyusutanAktiva penyusutanAktiva = ctrlPenyusutanAktiva.getPenyusutanAktiva();
int iErrCode = ctrlPenyusutanAktiva.action(iCommand,0,list,currentPeriodOid);
String msgString = ctrlPenyusutanAktiva.getMessage();


%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdsearch(){
	document.frmorderaktiva.command.value="<%=Command.LIST%>";
	document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

function cmdSave(){
	document.frmorderaktiva.command.value="<%=Command.SAVE%>";
    document.frmorderaktiva.action="penyusutan_aktiva.jsp";
	document.frmorderaktiva.submit();
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr>
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE">
      <%@ include file = "../main/header.jsp" %>
    </td>
  </tr>
  <tr>
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer">
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr>
    <td width="88%" valign="top" align="left">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%>
            &gt; <%=listTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td><!-- #BeginEditable "content" -->
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
                        <td width="84%" height="25"><%=periode.getNama()%></td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][1]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25">
                          <%
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
                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_TYPE_PENYUSUTAN","",null,""+typePenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> </td>
                        <td width="1%" height="25"><b>:</b></td>
                        <td width="84%" height="25"><%
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
                          }
                          out.println(ControlCombo.draw("TYPE_AKTIVA_METODE_PENYUSUTAN","",null,""+metodepenyusutanId,vAktivaKey,vAktivaVal,""));
				          %>
                        </td>
                      </tr>
                      <tr>
                        <td width="15%" height="25">&nbsp;</td>
                        <td width="1%" height="25">&nbsp;</td>
                        <td width="84%" height="25">&nbsp;<a href="javascript:cmdsearch()"><b>Cari Aktiva</b></a></td>
                      </tr>
                      <tr>
                        <td colspan="3"> </td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="3"><%=drawList(SESS_LANGUAGE,iCommand,list,currentPeriodOid)%></td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;<a href="javascript:cmdSave()"><b>Simpan Penyusutan</b></a></td>
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
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="2" height="20" class="footer">
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%//}%>
