<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>  
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.periode.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>

<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;
%>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->
<%!
public static String strTitle[][] = 
{
	{
		"Kode Aktiva",
		"Nama Aktiva",
		"Jenis Aktiva",
		"Tipe Penyusutan",
		"Metode Penyusutan"
	},	
	{
		"Aktiva Number",
		"Aktiva Name",
        	"Jenis Aktiva",
        	"Tipe Penyusutan",
        	"Metode Penyusutan"
	}
};

public static final String masterTitle[] = 
{
	"Master Data","Master Data"
};

public static final String searchTitle[] = 
{
	"Pencarian Aktiva","Search Aktiva"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody)
{
	String result = "";
	if(addBody)
	{
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
		{	
			result = textJsp[language][index] + " " + prefiks;
		}
		else
		{
			result = prefiks + " " + textJsp[language][index];		
		}
	}
	else
	{
		result = textJsp[language][index];
	} 
	return result;
}
%>


<%
int iCommand = FRMQueryString.requestCommand(request);

String orderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL];
SrcModulAktiva srcModulAktiva = new SrcModulAktiva();
if(session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA)!=null)
{
	srcModulAktiva = (SrcModulAktiva)session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Aktiva" : "Aktiva";
String strAdd = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);
try
{
	session.removeValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
}
catch(Exception e)
{
	System.out.println("--- Remove session error ---");
}

CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
	<%if(privAdd){%>
	function cmdAdd(){
		document.frmsearchju.command.value="<%=Command.ADD%>";
		document.frmsearchju.add_type.value="<%=ADD_TYPE_SEARCH%>";		
		document.frmsearchju.action="modul_aktiva_edit.jsp";
		document.frmsearchju.submit();
	}
	<%}%>
	
	function cmdSearch(){
		document.frmsearchju.command.value="<%=Command.LIST%>";
		document.frmsearchju.action="modul_aktiva_own_list.jsp";
		document.frmsearchju.submit();
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
    <td  height="1" ID="TOPTITLE">
      <%///@ include file = "../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td height="1" ID="MAINMENU" >
      <%///@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> &gt; <%=searchTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmsearchju" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">			  			  			  			  
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td colspan="3"> 
                    <hr>
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_KODE_AKTIVA]%>" size="20" value="<%=srcModulAktiva.getKodeAktiva()%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_NAMA_AKTIVA]%>" size="50" value="<%=srcModulAktiva.getNamaAktiva()%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">                            <%
                          Vector vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_JENIS_AKTIVA,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          Vector vAktivaKey = new Vector(1,1);
                          Vector vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add("Select...");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_JENIS_AKTIVA_ID],"",null,""+srcModulAktiva.getJenisAktivaId(),vAktivaKey,vAktivaVal,""));
				          %>
                  </td>
                </tr>
                <tr> 
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">                            <%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add("Select...");
                          for(int k=0;k < vtAktiva.size();k++){
                            Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                            vAktivaKey.add(""+aktiva.getOID());
                            vAktivaVal.add(aktiva.getNama());
                          }
                          out.println(ControlCombo.draw(FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_TIPE_PENYUSUTAN_ID],"",null,""+srcModulAktiva.getTipePenyusutanId(),vAktivaKey,vAktivaVal,""));
				          %>
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <%
                    vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                            "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                    vAktivaKey = new Vector(1,1);
                    vAktivaVal = new Vector(1,1);
                      vAktivaKey.add("0");
                      vAktivaVal.add("Select...");
                    for(int k=0;k < vtAktiva.size();k++){
                      Aktiva aktiva = (Aktiva)vtAktiva.get(k);

                      vAktivaKey.add(""+aktiva.getOID());
                      vAktivaVal.add(aktiva.getNama());
                    }
                    out.println(ControlCombo.draw(FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_METODE_PENYUSUTAN_ID],"",null,""+srcModulAktiva.getMetodepenyusutanId(),vAktivaKey,vAktivaVal,""));
				    %>
                  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">                  <input type="submit" name="Search" value="<%=strSearch%>" onClick="javascript:cmdSearch()"></td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="1">
      <%//@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>