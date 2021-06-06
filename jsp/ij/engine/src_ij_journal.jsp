<%@ page language="java" %>
<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.payment.*" %>
<!-- package ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>
<%@ page import = "com.dimata.ij.ibosys.*" %>
<%@ page import = "com.dimata.ij.entity.search.*" %>
<%@ page import = "com.dimata.ij.form.search.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<!-- JSP Block -->
<%
FrmSrcIjJournal objFrmSrcIjJournal = new FrmSrcIjJournal();

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="javascript">
function cmdSearch()
{
	document.frmsrcjournal.action="ij_journal_list.jsp";
	document.frmsrcjournal.submit();	
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Journal 
            &gt; Search Journal<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcjournal" method="post" action="">
              <input type="hidden" name="command" value="">
              <table width="100%" border="0" cellspacing="2" cellpadding="1">
                <tr> 
                  <td colspan="3"> 
                    &nbsp;
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="60%" nowrap>Sistem Back Office</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%"> 
                    <%
				  out.println(ControlCombo.draw("BO_SYSTEM", null, "", vectBOKey, vectBOVal, "", ""));
				  %>
                  </td>
                </tr>
                <tr> 
                  <td rowspan="2" height="180%" valign="top" nowrap width="11%">Tgl 
                    Transaksi</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%"> 
                    <input type="radio" name="<%=objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_SELECTED_TRANS_DATE]%>" value="<%=objFrmSrcIjJournal.SELECTED_ALL_DATE%>" checked>
                    All Transaction Date</td>
                </tr>
                <tr> 
                  <td width="1%">&nbsp;</td>
                  <td width="88%"> 
                    <input type="radio" name="<%=objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_SELECTED_TRANS_DATE]%>" value="<%=objFrmSrcIjJournal.SELECTED_USER_DATE%>">
                    Dari <%=ControlDate.drawDate(objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_TRANS_START_DATE], new Date(), 0, -1)%> sampai <%=ControlDate.drawDate(objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_TRANS_END_DATE], new Date(), 0, -1)%></td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" nowrap>Dok. Referensi</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%" valign="top"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <input type="text" name="<%=objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_BILL_NUMBER]%>" size="25" value="">
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%" nowrap>Nama Kontak</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%" valign="top"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <input type="text" name="<%=objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_CONTACT_NAME]%>" size="40" value="">
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%">Tipe Currency</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <%
						Vector vectKeyCurrency = new Vector(1,1);
						Vector vectValCurrency = new Vector(1,1);								
						
						vectKeyCurrency.add("0");  
						vectValCurrency.add("All Currency");																					

						PstCurrencyType objPstCurrencyType = new PstCurrencyType();
						String strOrder = objPstCurrencyType.fieldNames[objPstCurrencyType.FLD_TAB_INDEX];
						Vector listCurrAiso = objPstCurrencyType.list(0, 0, "", strOrder);  
						if(listCurrAiso!=null && listCurrAiso.size()>0)
						{
							int maxCurrencyType = listCurrAiso.size();
							for(int i=0; i<maxCurrencyType; i++)
							{
								CurrencyType objCurrencyType = (CurrencyType) listCurrAiso.get(i);                 					
								vectKeyCurrency.add(""+objCurrencyType.getOID());
								vectValCurrency.add(objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");						
							}
						}
						
						out.println(ControlCombo.draw(objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_TRANS_CURRENCY], null, "", vectKeyCurrency, vectValCurrency, ""));	
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%">Status Jurnal</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <%
						Vector vectStatusKey = new Vector(1,1);
						Vector vectStatusVal = new Vector(1,1);
																								
						vectStatusKey.add("-1");
						vectStatusVal.add("All Status");						

						vectStatusKey.add(""+I_DocStatus.DOCUMENT_STATUS_DRAFT);
						vectStatusVal.add(""+I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]);						

						vectStatusKey.add(""+I_DocStatus.DOCUMENT_STATUS_POSTED);
						vectStatusVal.add(""+I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_POSTED]);						

						out.println(ControlCombo.draw(objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_JOURNAL_STATUS], null, "", vectStatusKey, vectStatusVal, "", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%">Urut Berdasar</td>
                  <td width="1%"><b>:</b></td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td height="17"> 
                          <%
						Vector vectUrutKey = new Vector(1,1);
						Vector vectUrutVal = new Vector(1,1);
						
						vectUrutKey.add(""+objFrmSrcIjJournal.SORT_BY_TRANS_DATE);
						vectUrutVal.add(""+objFrmSrcIjJournal.sortFieldNames[SESS_LANGUAGE][objFrmSrcIjJournal.SORT_BY_TRANS_DATE]);						

						vectUrutKey.add(""+objFrmSrcIjJournal.SORT_BY_BILL_NUMBER);
						vectUrutVal.add("Dok. Referensi");						

						vectUrutKey.add(""+objFrmSrcIjJournal.SORT_BY_CURRENCY);
						vectUrutVal.add(""+objFrmSrcIjJournal.sortFieldNames[SESS_LANGUAGE][objFrmSrcIjJournal.SORT_BY_CURRENCY]);						

						vectUrutKey.add(""+objFrmSrcIjJournal.SORT_BY_JOURNAL_STATUS);
						vectUrutVal.add(""+objFrmSrcIjJournal.sortFieldNames[SESS_LANGUAGE][objFrmSrcIjJournal.SORT_BY_JOURNAL_STATUS]);						

						out.println(ControlCombo.draw(objFrmSrcIjJournal.fieldNames[objFrmSrcIjJournal.FRM_ORDER_BY], null, "", vectUrutKey, vectUrutVal, "", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td width="11%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="88%"> 
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                      <tr> 
                        <td> 
                          <input type="submit" name="Search" value="Search Journal" onClick="javascript:cmdSearch()">
                        </td>
                      </tr>
                    </table>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
