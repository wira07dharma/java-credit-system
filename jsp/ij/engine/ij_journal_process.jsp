<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>

<%@ page language="java" %>

<!-- import dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>

<!-- import common-->
<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>

<!-- import harisma-->
<%@ page import = "com.dimata.common.entity.location.Location" %>
<%@ page import = "com.dimata.common.entity.location.PstLocation" %>
<%@ page import = "com.dimata.common.entity.custom.DataCustom" %>
<%@ page import = "com.dimata.common.entity.custom.PstDataCustom" %>

<!-- import ij-->
<%@ page import = "com.dimata.ij.entity.configuration.*" %>
<%@ page import = "com.dimata.ij.form.configuration.*" %>
<%@ page import = "com.dimata.ij.session.engine.*" %>

<%@ include file = "../../main/javainit.jsp" %>

<!-- JSP Block -->
<%!
/**
 * untuk data custom lokasi
 * @param userID
 * @return
 */
public String ctrCheckBoxCustomLokasi(long userID)
{
    ControlCheckBox chkBx=new ControlCheckBox();
    chkBx.setCellSpace("0");
    chkBx.setCellStyle("");
    chkBx.setWidth(4);
    chkBx.setTableAlign("left");
    chkBx.setCellWidth("10%");

	try
	{
		Vector checkValues = new Vector(1,1);
		Vector checkCaptions = new Vector(1,1);
				
		String orderBy = PstLocation.fieldNames[PstLocation.FLD_NAME];
		Vector listLocat = PstLocation.list(0,0,"",orderBy); 
		if(listLocat!=null && listLocat.size()>0)
		{
			Vector userCustoms = PstDataCustom.getDataCustom(userID);		
			if(userCustoms!=null && userCustoms.size()>0)
			{		
				int maxCust = userCustoms.size();					
				int maxV = listLocat.size();
				int maxVI = maxV + 1;
				System.out.println("maxV IJ ====> "+maxV);
				for(int i=0; i<maxV; i++)
				{
					Location location = (Location) listLocat.get(i);
					System.out.println("looping i IJ ===> "+i);
					
					/*checkValues.add(Long.toString(location.getOID()));
					checkCaptions.add(location.getName());
					break;*/		
							
					for(int j=0; j<maxCust; j++)
					{
						DataCustom dataCustom = (DataCustom) userCustoms.get(j);
						if(location.getOID() == Long.parseLong(""+dataCustom.getDataValue()))
						{
							checkValues.add(Long.toString(location.getOID()));
							checkCaptions.add(location.getName());
							break;							
						}							
					}				
				}
			}
		}
		System.out.println("Lokasi IJ checkValues.size() ====> "+checkValues.size());
		chkBx.setTableWidth("60%");
		String fldName = "TRANS_LOCATION";
		return chkBx.draw(fldName,checkValues,checkCaptions,new Vector(1,1));

	}
	catch (Exception exc)
	{
		return "No location assigned";
	}
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
Date startDate = FRMQueryString.requestDate(request,"TGL_TRANSAKSI_MULAI");
Date endDate = FRMQueryString.requestDate(request,"TGL_TRANSAKSI_AKHIR");
int iBoSystemSelected = FRMQueryString.requestInt(request,"BO_SYSTEM");
String sArrLocation[] = request.getParameterValues("TRANS_LOCATION");
Vector vLocation = new Vector(1,1);
if(sArrLocation!=null && sArrLocation.length>0)
{
	int iArrLocation = sArrLocation.length;
	for(int i=0; i<iArrLocation; i++)
	{
		vLocation.add(""+sArrLocation[i]);		
	}
}

String strMessage = "";
if(iCommand == Command.SUBMIT)
{
	int result = 0;	
	if(startDate!=null && endDate!=null)
	{
		Periode objPeriod = PstPeriode.fetchExc(currentPeriodOid);
		if(objPeriod.getOID() != 0)
		{			
			IjEngineParam objIjEngineParam = new IjEngineParam();
			objIjEngineParam.setDStartTransactionDate(startDate);
			objIjEngineParam.setDFinishTransactionDate(endDate); 
			objIjEngineParam.setIBoSystem(iBoSystemSelected);    
			objIjEngineParam.setVLocationOid(vLocation);
			objIjEngineParam.setLBookType(accountingBookType);
			objIjEngineParam.setILanguage(SESS_LANGUAGE);                   
			objIjEngineParam.setLCurrPeriodeOid(objPeriod.getOID());                   
			objIjEngineParam.setDStartDatePeriode(objPeriod.getTglAwal());                   
			objIjEngineParam.setDEndDatePeriode(objPeriod.getTglAkhir());                    
			objIjEngineParam.setDLastEntryDatePeriode(objPeriod.getTglAkhirEntry());                    
			objIjEngineParam.setLOperatorOid(userOID);

            System.out.println("objIjEngineParam.getDStartTransactionDate() : "+objIjEngineParam.getDStartTransactionDate());
            System.out.println("objIjEngineParam.setDFinishTransactionDate() : "+objIjEngineParam.getDFinishTransactionDate());
            System.out.println("objIjEngineParam.setIBoSystem() : "+objIjEngineParam.getIBoSystem());
            System.out.println("objIjEngineParam.setVLocationOid() : "+objIjEngineParam.getVLocationOid());
            System.out.println("objIjEngineParam.setLBookType() : "+objIjEngineParam.getLBookType());
            System.out.println("objIjEngineParam.setILanguage() : "+objIjEngineParam.getILanguage());
            System.out.println("objIjEngineParam.setLCurrPeriodeOid() : "+objIjEngineParam.getLCurrPeriodeOid());
            System.out.println("objIjEngineParam.setDEndDatePeriode() : "+objIjEngineParam.getDEndDatePeriode());
            System.out.println("objIjEngineParam.setDLastEntryDatePeriode() : "+objIjEngineParam.getDLastEntryDatePeriode());
            System.out.println("objIjEngineParam.setLOperatorOid() : "+objIjEngineParam.getLOperatorOid());


			// process interactive journal
			IjEngineController objIjEngineController = new IjEngineController();
			result = objIjEngineController.runIJJournalProcess(objIjEngineParam);
		}
	}
	
	strMessage = "Interactive process journal finish ...\n" + result + " journal created ...";
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="javascript">
function cmdProcess()
{
	document.frmjournal.command.value="<%=Command.SUBMIT%>";
	document.frmjournal.action="ij_journal_process.jsp";
	document.frmjournal.submit();
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
            &gt; Journal Process<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmjournal" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" border="0" cellspacing="2" cellpadding="2">
                <tr> 
                  <td colspan="3">&nbsp; 
                    
                  </td>
                </tr>
                <tr> 
                  <td width="12%"> Sistem Back Office</td>
                  <td width="1%"><b>:</b></td>
                  <td width="87%"> 
                  <%
				  out.println(ControlCombo.draw("BO_SYSTEM", null, ""+iBoSystemSelected, vectBOKey, vectBOVal, "", ""));
				  %>
                  </td>
                </tr>
                <tr> 
                  <td width="12%">Lokasi</td>
                  <td width="1%"><b>:</b></td>
                  <td width="87%"><%=ctrCheckBoxCustomLokasi(userOID)%></td>
                </tr>
                <tr> 
                  <td width="12%">Periode Transaksi</td>
                  <td width="1%"><b>:</b></td>
                  <td width="87%"><%=ControlDate.drawDate("TGL_TRANSAKSI_MULAI", new Date(), 0, -5)%> sampai <%=ControlDate.drawDate("TGL_TRANSAKSI_AKHIR", new Date(), 0, -5)%></td>
                </tr>
                <tr> 
                  <td width="12%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="87%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="12%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="87%"><a href="javascript:cmdProcess()" class="command">Generate 
                    Journal</a></td>
                </tr>
                <tr> 
                  <td colspan="3"><%=strMessage%></td>
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
