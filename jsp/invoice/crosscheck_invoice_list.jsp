<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.invoice.*,
		 com.dimata.aiso.entity.invoice.*,
		 com.dimata.aiso.entity.masterdata.*,   
		 com.dimata.aiso.entity.search.SrcCrossCheckData,
		 com.dimata.aiso.form.search.FrmSrcCrossCheckData,
		 com.dimata.common.entity.system.PstSystemProperty,
		 com.dimata.harisma.entity.masterdata.*,
		 com.dimata.aiso.entity.periode.*,
		 com.dimata.aiso.entity.report.*,
		 com.dimata.aiso.form.invoice.*,
                 com.dimata.common.entity.contact.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.util.Command,
		 com.dimata.qdep.entity.I_DocStatus,
                 com.dimata.util.Formater" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

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
}
else
{
%>

<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"No.",
		"Nomor Jurnal",
		"Nomor Referensi",	
		"Tanggal Jurnal",
		"Keterangan",	
		"Jumlah",		
		"Data Buku Besar dan Buku Pembantu Hutang Piutang sudah sesuai"			
	},
	{
		"No.",
		"Journal Number",
		"Ref Number",	
		"Journal Date",
		"Journal Description",	
		"Amount",
		"Congratulation. General Ledger and AR / AP data are balanced."
	}
};

public static String strTitleArap[][] = 
{
	{
		"No.",
		"Nomor Voucher",
		"Nomor Nota",	
		"Tanggal Nota",
		"Nama Kontak",	
		"Jumlah",		
		"Data Buku Besar dan Buku Pembantu Hutang Piutang sudah sesuai"			
	},
	{
		"No.",
		"Voucher Number",
		"Invoice Number",	
		"Invoice Date",
		"Contact Name",	
		"Amount",
		"Congratulation. General Ledger and AR / AP data are balanced."
	}
};

public static String strTitleArapPayment[][] = 
{
	{
		"No.",
		"Nomor Pembayaran",
		"Nomor Nota",	
		"Tanggal Nota",
		"Nama Kontak",	
		"Jumlah",		
		"Data Buku Besar dan Buku Pembantu Pembayaran Hutang Piutang sudah sesuai"			
	},
	{
		"No.",
		"Payment Number",
		"Invoice Number",	
		"Invoice Date",
		"Contact Name",	
		"Amount",
		"Congratulation. General Ledger and AR/AP Payment data are balanced."
	}
};


public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Hasil Pencocokan",
	"Cross Check Data"
};

public String getContactName(ContactList objContactList){
	if(objContactList != null){
		try{
			if(objContactList.getCompName() != null){
				return objContactList.getCompName();
			}else{
				return objContactList.getPersonName();
			}
		}catch(Exception e){}
	}
	return "";
}

public String getInvoiceType(InvoiceMain objInvoiceMain, int iLanguage){
	if(objInvoiceMain != null){
		try{
			if(objInvoiceMain.getType() == 0){
				String strTicket = iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Ticket" : "Tiket";
				return strTicket;
			}else{
				String strPackage = iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Package" : "Paket";
				return strPackage;
			}
		}catch(Exception e){}
	}
	return "";
}

public boolean getTruedFalse(Vector vectInvoiceMainId, long lInvoiceId){
	for(int i=0;i<vectInvoiceMainId.size();i++){
		long lInvoiceIdSelect = Long.parseLong((String)vectInvoiceMainId.get(i));
		if(lInvoiceIdSelect == lInvoiceId)
			return true;
	}
	return false;
}

public String drawListInvoice(Vector objectClass, int language){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"50%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"17%","center","right");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	
	ctrlist.reset();
	int index = -1;
	GLCheck objGLCheck = new GLCheck();
	double dAmount = 0.0;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			objGLCheck = (GLCheck)objectClass.get(i);			
			
			Vector rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(objGLCheck.getJournalNo());
			rowx.add(objGLCheck.getDokRef());
			rowx.add(Formater.formatDate(objGLCheck.getTransDate(),"dd-MM-yyyy"));
			rowx.add(objGLCheck.getDescription());
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objGLCheck.getAmount())+"</div>");			

			lstData.add(rowx);
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}

public String drawListArap(Vector objectClass, int language){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitleArap[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitleArap[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitleArap[language][2],"10%","center","left");
	ctrlist.dataFormat(strTitleArap[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitleArap[language][4],"50%","center","left");
	ctrlist.dataFormat(strTitleArap[language][5],"17%","center","right");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	
	ctrlist.reset();
	int index = -1;
	ArapCheck objArapCheck = new ArapCheck();
	double dAmount = 0.0;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			objArapCheck = (ArapCheck)objectClass.get(i);			
			
			Vector rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(objArapCheck.getVoucherNo());
			rowx.add(objArapCheck.getNotaNo());
			rowx.add(Formater.formatDate(objArapCheck.getNotaDate(),"dd-MM-yyyy"));
			rowx.add((objArapCheck.getContactName() == null? "" : objArapCheck.getContactName()));
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objArapCheck.getAmount())+"</div>");			

			lstData.add(rowx);
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}

public String drawListArapPayment(Vector objectClass, int language){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitleArapPayment[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitleArapPayment[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitleArapPayment[language][2],"10%","center","left");
	ctrlist.dataFormat(strTitleArapPayment[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitleArapPayment[language][4],"50%","center","left");
	ctrlist.dataFormat(strTitleArapPayment[language][5],"17%","center","right");

	ctrlist.setLinkRow(1);
	ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	
	ctrlist.reset();
	int index = -1;
	PaymentCheck objPaymentCheck = new PaymentCheck();
	ContactList objContactList = new ContactList();	
	double dAmount = 0.0;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			objPaymentCheck = (PaymentCheck)objectClass.get(i);			
			
			if(objPaymentCheck.getContactId() != 0){
			    objContactList = PstContactList.fetchExc(objPaymentCheck.getContactId());
			}
			
			Vector rowx = new Vector();
			rowx.add(""+(i+1));
			rowx.add(objPaymentCheck.getPaymentNo());
			rowx.add(objPaymentCheck.getNotaNo());
			rowx.add(Formater.formatDate(objPaymentCheck.getNotaDate(),"dd-MM-yyyy"));
			rowx.add((objContactList.getCompName() == null? "" : objContactList.getCompName()));
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(objPaymentCheck.getAmount())+"</div>");			

			lstData.add(rowx);
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long invoiceMainId = FRMQueryString.requestLong(request, "invoice_main_id");
int iQueryType = FRMQueryString.requestInt(request, "query_type");
int recordToGet = 20;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.initDefault(SESS_LANGUAGE,"");
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice" : "Invoice";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Cross Check Proses" : "Kembali Ke Proses Pencocokan";

SrcCrossCheckData objSrcCrossCheckData = new SrcCrossCheckData();
FrmSrcCrossCheckData frmSrcCrossCheckData = new FrmSrcCrossCheckData(request); 

if((iCommand == Command.BACK) && (session.getValue("WHERE_CLAUSE")!=null)){
	objSrcCrossCheckData = (SrcCrossCheckData)session.getValue("WHERE_CLAUSE");
}else{
	frmSrcCrossCheckData.requestEntityObject(objSrcCrossCheckData);
}


if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		objSrcCrossCheckData = (SrcCrossCheckData)session.getValue("WHERE_CLAUSE");
	}catch(Exception e){
	objSrcCrossCheckData = new SrcCrossCheckData();
		
	}
}



if(objSrcCrossCheckData == null){
	objSrcCrossCheckData = new SrcCrossCheckData();
}



int arapType = 0;
int debetCredit = 0;
if(objSrcCrossCheckData != null){
    arapType = objSrcCrossCheckData.getTypeArap();
    debetCredit = objSrcCrossCheckData.getTypeTrans();
    System.out.println("arapType ::::::::::::::::::::::::::::::::::::::::::::::::::::: "+arapType);
}

SessInvoice sessInvoice = new SessInvoice();	
Vector vListInvoice = new Vector(1,1);
    try{
	if(objSrcCrossCheckData.getTypeCrossCheck() == 0){
	    vListInvoice = sessInvoice.vListCrossCheckResult(arapType, debetCredit);
	}else{
	    if(objSrcCrossCheckData.getTypeTrans() == PstPerkiraan.ACC_DEBETSIGN){ 
		vListInvoice = sessInvoice.listCrossCheckToArap(arapType, debetCredit);
	    }else{
		vListInvoice = sessInvoice.listCrossCheckToArapPayment(arapType, debetCredit);
	    }
	}
    }catch(Exception e){}  



%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">

function cmdBack(){
	document.frmsrcorderaktiva.command.value="<%=Command.BACK%>";
	document.frmsrcorderaktiva.action="crosscheck_invoice_search.jsp";
	document.frmsrcorderaktiva.submit();
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
            <form name="frmsrcorderaktiva" method="post" action="">
              <input type="hidden" name="order_aktiva_id" value="0">
			  <input type="hidden" name="invoice_main_id" value="<%=invoiceMainId%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			
			  <input type="hidden" name="query_type" value="<%=iQueryType%>">  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
			  <table width="100%">
			  	<tr>
				<td>			
                <%if((vListInvoice!=null)&&(vListInvoice.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);
				  if(objSrcCrossCheckData.getTypeCrossCheck() == 0){
					out.println(drawListInvoice(vListInvoice, SESS_LANGUAGE));
				  }else{
				      if(objSrcCrossCheckData.getTypeTrans() == PstPerkiraan.ACC_DEBETSIGN){ 
					    out.println(drawListArap(vListInvoice, SESS_LANGUAGE));
					}else{
					    out.println(drawListArapPayment(vListInvoice, SESS_LANGUAGE));
					}
				  }
				  %>
				</td>
				</tr>
				<tr>
				<td>                                 
                <%} else {%>
				</td>
				</tr>
				<tr>
				<td>
				<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
				<tr>
				<td>
					<table width="100%" class="listgensellOdd">		
					<tr><td>&nbsp;</td></tr>		
					<tr> 
					  <td><div align="center"><span class="errfont"><%=strTitle[SESS_LANGUAGE][6]%></span></div></td>
					</tr>
					<tr><td>&nbsp;</td></tr>					
				  </table>
				 </td>
				 </tr>
				 </table> 
                <%  }	%>
				</td>
				</tr>
				<tr>
				<td>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
					  <td height="16" class="command">
					  		<a href="javascript:cmdBack()"><%=strBack%></a>
					  </td>
					</tr>
              </table>
			  </td>
			  </tr>
			  </table>
            </form>
			<script language="javascript">
				<%if(iCommand == Command.POST){%>
					list();
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>