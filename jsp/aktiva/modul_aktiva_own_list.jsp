<%@ page language="java" %> 
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.masterdata.SessModulAktiva,
                 com.dimata.aiso.form.masterdata.CtrlModulAktiva,
                 com.dimata.aiso.form.aktiva.FrmOrderAktivaItem" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %> 
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.periode.*" %>
<%@ page import="com.dimata.aiso.form.search.*" %>
<%@ page import="com.dimata.aiso.session.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.aktiva.SessListAktivaOwn" %>


<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 

%>
<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{	"No.",
		"Kode",
		"Nama",
		"Harga Perolehan",
		"Nilai Buku",		
        "Tidak ada daftar data aktiva",
		"Kode Aktiva",
		"Nama Aktiva",
		"Jenis Aktiva",
		"Tipe Penyusutan",
		"Metode Penyusutan"
	},
	{	"No.",
		"Code",
		"Name",
		"Acquisition Value",
        "Book Value",        
        "Data not found",
		"Fixed Assets Code",
		"Fixed Assets Name",
        "Fixed Assets Type",
        "Depreciation Type",
        "Depreciation Method"
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Inventaris",
	"Fixed Assets"
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


public String listDrawModulAktiva(FRMHandler objFRMHandler, Vector objectClass, int language)
{
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"5%","center","left");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"45%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"20%","center","left");
	
	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	System.out.println("DIATAS TRY JSP :::::: ");
	try
	{
		System.out.println("DIATAS FOR JSP :::::: ");
		for (int i = 0; i < objectClass.size(); i++) 
		{
			 Vector vect = (Vector)objectClass.get(i);
			 System.out.println("ISI VECTOR VECT JSP ::::: "+ vect);
			 ModulAktiva modulAktiva = (ModulAktiva)vect.get(0);
			 
			//Aktiva aktiva = (Aktiva)vect.get(1);

			System.out.println("DIDALAM FOR JSP :::::: ");			 

			 Vector rowx = new Vector();
			 rowx.add("<div align=\"center\">"+(i+1)+"</div>"); 
			 rowx.add(modulAktiva.getKode());
             	 rowx.add(modulAktiva.getName());
			 rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getHargaPerolehan())+"</div>");
            	 rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(modulAktiva.getNilaiBuku())+"</div>");
            	 System.out.println(""+modulAktiva.getNilaiBuku());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(modulAktiva.getOID())+"','"+modulAktiva.getKode()+"','"+modulAktiva.getName()+"','"+Formater.formatNumber(modulAktiva.getHargaPerolehan(),"###"));
		}
     }
	 catch(Exception e)
	 {
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
String kodeBrg = FRMQueryString.requestString(request, FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_KODE_AKTIVA]);
int recordToGet = 15;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.initDefault(SESS_LANGUAGE,"");
String strAll = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "All" : "Semua";  
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";
String strSearch = ctrlLine.getCommand(SESS_LANGUAGE,listTitle[SESS_LANGUAGE],ctrlLine.CMD_SEARCH,true);


SrcModulAktiva srcModulAktiva = new SrcModulAktiva();
FrmSrcModulAktiva frmSrcModulAktiva = new FrmSrcModulAktiva(request);
if((iCommand==Command.BACK) && (session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA)!=null)){
	srcModulAktiva = (SrcModulAktiva)session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
	srcModulAktiva.setKodeAktiva(kodeBrg);
}else{
	frmSrcModulAktiva.requestEntityObject(srcModulAktiva);
}


try{
	session.removeValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcModulAktiva = (SrcModulAktiva)session.getValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA);
	}catch(Exception e){
		srcModulAktiva = new SrcModulAktiva();
	}
}

if(srcModulAktiva==null){
	srcModulAktiva = new SrcModulAktiva();
} 

session.putValue(SessModulAktiva.SESS_SEARCH_MODUL_AKTIVA, srcModulAktiva);

SessListAktivaOwn objListAktivaOwn = new SessListAktivaOwn();
vectSize = SessListAktivaOwn.countAktivaOwn(srcModulAktiva);

if(iCommand!=Command.BACK){
	if((iCommand==Command.NONE)||(iCommand==Command.LIST)){
		iCommand = Command.LAST;	
	}
	CtrlModulAktiva objCtrlModulAktiva = new CtrlModulAktiva(request);
	start = objCtrlModulAktiva.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
Vector listAktivaOwn = objListAktivaOwn.listAktivaOwn(srcModulAktiva, start, recordToGet);
   // System.out.println("--- nilai : "+listModulAktiva);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
function cmdEdit(oid, code, aktivaName, price){
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_AKTIVA_ID]%>.value = oid;
    self.opener.document.forms.frmorderaktiva.aktiva_code.value = code;
    self.opener.document.forms.frmorderaktiva.aktiva_name.value = aktivaName;
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_QTY]%>.value = "1";
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_PRICE]%>.value = price;
    self.opener.document.forms.frmorderaktiva.<%=FrmOrderAktivaItem.fieldNames[FrmOrderAktivaItem.FRM_TOTAL_PRICE]%>.value = price;
    self.close();
}

function first(){
	document.frmsrcju.command.value="<%=Command.FIRST%>"; 
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function prev(){
	document.frmsrcju.command.value="<%=Command.PREV%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function next(){
	document.frmsrcju.command.value="<%=Command.NEXT%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function last(){
	document.frmsrcju.command.value="<%=Command.LAST%>";
	document.frmsrcju.action="modul_aktiva_list.jsp";
	document.frmsrcju.submit();
}

function cmdBack(){
	document.frmsrcju.command.value="<%=Command.BACK%>";
	document.frmsrcju.action="selling_aktiva_detail.jsp";
	document.frmsrcju.submit();
}
<%if(privAdd){%>
function cmdAdd(){
	document.frmsearchju.command.value="<%=Command.ADD%>";
	document.frmsearchju.add_type.value="<%=ADD_TYPE_SEARCH%>";		
	document.frmsearchju.action="modul_aktiva_edit.jsp";
	document.frmsearchju.submit();
}
<%}%>	
function cmdSearch(){
	document.frmsrcju.command.value="<%=Command.LIST%>";
	document.frmsrcju.action="modul_aktiva_own_list.jsp";
	document.frmsrcju.submit();
}

function cmdCancel(){
	window.close();
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcju" method="post" action="">
              <input type="hidden" name="hidden_modul_aktiva_id" value="0">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
                
			<table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr> 
                  <td colspan="3">&nbsp; 
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,listTitle[SESS_LANGUAGE],false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_KODE_AKTIVA]%>" size="20" value="<%=srcModulAktiva.getKodeAktiva()%>">			  	
                  </td>
                </tr>
                <tr> 
                  <td width="16%" nowrap><%=getJspTitle(strTitle,7,SESS_LANGUAGE,listTitle[SESS_LANGUAGE],false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcModulAktiva.fieldNames[FrmSrcModulAktiva.FRM_SEARCH_NAMA_AKTIVA]%>" size="50" value="<%=srcModulAktiva.getNamaAktiva()%>">
                  </td>
                </tr>
                <tr> 
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,8,SESS_LANGUAGE,listTitle[SESS_LANGUAGE],false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">                            <%
                          Vector vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_JENIS_AKTIVA,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          Vector vAktivaKey = new Vector(1,1);
                          Vector vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][8]);
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
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,9,SESS_LANGUAGE,listTitle[SESS_LANGUAGE],false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">                            <%
                          vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                                  "="+PstAktiva.TYPE_AKTIVA_TYPE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                          vAktivaKey = new Vector(1,1);
                          vAktivaVal = new Vector(1,1);
                            vAktivaKey.add("0");
                            vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][9]);
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
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,10,SESS_LANGUAGE,listTitle[SESS_LANGUAGE],false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <%
                    vtAktiva = PstAktiva.list(0,0,PstAktiva.fieldNames[PstAktiva.FLD_TYPE]+
                            "="+PstAktiva.TYPE_AKTIVA_METODE_PENYUSUTAN,PstAktiva.fieldNames[PstAktiva.FLD_KODE]);
                    vAktivaKey = new Vector(1,1);
                    vAktivaVal = new Vector(1,1);
                      vAktivaKey.add("0");
                      vAktivaVal.add(strAll+" "+strTitle[SESS_LANGUAGE][10]);
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
			

			<!-- ------------------------------------- Old Data ---------------------------------- -->
			<%if((listAktivaOwn!=null)&&(listAktivaOwn.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(listDrawModulAktiva(objFRMHandler,listAktivaOwn,SESS_LANGUAGE));
				  %>                            
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">				
                <tr> 
                  <td><span class="comment"><%=strTitle[SESS_LANGUAGE][5]%></span></td>
                </tr>
			  </table>
                <%  }	%>

              <table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
					  <td height="16" class="command">
					  <a href="javascript:cmdCancel()"><%=strBack%></a>
					  </td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
