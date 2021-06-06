 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<!-- package wihita -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "java.util.Date" %>

<!--package harisma -->
<%@ page import = "com.dimata.aiso.entity.invoice.*" %>
<%@ page import = "com.dimata.aiso.form.invoice.*" %>
<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.printman.*" %>
<%@ page import = "com.dimata.aiso.printout.*" %>


<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MD_EMPLOYEE, AppObjInfo.OBJ_EMPLOYEE_LANGUAGE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
	int prevCommand = FRMQueryString.requestInt(request, "prev_command");
	int iCommand = FRMQueryString.requestCommand(request);
	int start = FRMQueryString.requestInt(request,"start");
	long oidDivision = FRMQueryString.requestLong(request,"division");
	long oidDepartment = FRMQueryString.requestLong(request,"department");
	long oidSection = FRMQueryString.requestLong(request,"section");
	long oidPaySlipComp = FRMQueryString.requestLong(request,"section");
	String searchNrFrom = FRMQueryString.requestString(request,"searchNrFrom");
	String searchNrTo = FRMQueryString.requestString(request,"searchNrTo");
	String searchName = FRMQueryString.requestString(request,"searchName");
    int dataStatus = FRMQueryString.requestInt(request,"dataStatus");
	String codeComponenGeneral = FRMQueryString.requestString(request,"compCode");
	String compName = FRMQueryString.requestString(request,"compName");
	int aksiCommand = FRMQueryString.requestInt(request,"aksiCommand");
	long periodeId = FRMQueryString.requestLong(request,"periodId");
	int numKolom = FRMQueryString.requestInt(request,"numKolom");
	int statusSave = FRMQueryString.requestInt(request,"statusSave");
	int keyPeriod = FRMQueryString.requestInt(request,"paySlipPeriod");

%>
<%
	System.out.println("iCommand::::"+iCommand);
	int iErrCode = FRMMessage.ERR_NONE;
	String msgString = "";
	String msgStr = "";
	int recordToGet = 1000;
	int vectSize = 0;
	String orderClause = "";
	String whereClause = "";
	ControlLine ctrLine = new ControlLine();
	
	// action on object agama defend on command entered
	iErrCode = ctrlPaySlipComp.action(iCommand , oidPaySlipComp);
	FrmPaySlipComp frmPaySlipComp = ctrlPaySlipComp.getForm();
	PaySlipComp paySlipComp = ctrlPaySlipComp.getPaySlipComp();
	msgString =  ctrlPaySlipComp.getMessage();
	
	/*if(iCommand == Command.SAVE && prevCommand == Command.ADD)
	{
		start = PstPaySlip.findLimitStart(oidEmployee,recordToGet, whereClause,orderClause);
		vectSize = PstEmployee.getCount(whereClause);
	}
	else
	{
		vectSize = sessEmployee.countEmployee(srcEmployee);
	}

	
	if((iCommand==Command.FIRST)||(iCommand==Command.NEXT)||(iCommand==Command.PREV)||
	(iCommand==Command.LAST)||(iCommand==Command.LIST))
		start = ctrlPaySlip.actionList(iCommand, start, vectSize, recordToGet);*/
%>
<%
	
	
	//get the kode component name by componentId
	/*PayComponent payComponent = new PayComponent();
	String codeComponenGeneral ="";
	try{
		payComponent = PstPayComponent.fetchExc(componentId);
		codeComponenGeneral = payComponent.getCompCode();
	  }
	catch(Exception e){
	}*/
	
	
Vector listEmpPaySlip = new Vector(1,1);
	if(iCommand == Command.LIST || iCommand==Command.EDIT || iCommand == Command.SAVE || iCommand == Command.ADD || iCommand == Command.PRINT)
		{
			listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment,oidDivision,oidSection,searchNrFrom,searchNrTo,searchName,periodeId);			
			/*if(listEmpPaySlip.size()==0){
				//listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment,oidDivision,oidSection,searchNrFrom,searchNrTo,searchName,0);			
			}*/
		}
%>

<!-- JSP Block -->
<%!
public String drawList(int iCommand, FrmPaySlipComp frmObject, PaySlipComp objEntity, Vector objectClass, long idPaySlipComp, String codeComponent,String componentName){
	String result = "";
	Vector token = new Vector(1,1);
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("90%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader("No","2%", "2", "0");
	ctrlist.addHeader("Print","2%", "2", "0");
	ctrlist.addHeader("Employee Nr.","5%", "2", "0");
	ctrlist.addHeader("Nama","12%", "2", "0");
	ctrlist.addHeader("Position","12%", "2", "0");
	ctrlist.addHeader("Commencing Date","5%", "0", "0");
	ctrlist.addHeader("Salary Level","5%", "0", "0");
	ctrlist.addHeader("Start Date","5%", "0", "0");
	String checked = "";	
	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	Vector rowx = new Vector(1,1);
	int index = -1;
	String frmCurrency = "#,###";
	if(objectClass!=null && objectClass.size()>0){
		for(int i=0; i<objectClass.size(); i++){
			int total = 0;
			Vector temp = (Vector)objectClass.get(i);
			Employee employee = (Employee)temp.get(0);
			PayEmpLevel payEmpLevel = (PayEmpLevel)temp.get(1);
			PaySlip paySlip= (PaySlip)temp.get(2);
			rowx = new Vector();
				rowx.add(String.valueOf(1 + i));
				rowx.add("<input type=\"checkbox\" name=\"print"+i+"\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\"><input type=\"hidden\" name=\"employeeId\" value=\""+employee.getOID()+"\" class=\"formElemen\" size=\"10\">");
				rowx.add("<input type=\"hidden\" name=\"paySlipId\" value=\""+paySlip.getOID()+"\" class=\"formElemen\" size=\"10\">"+employee.getEmployeeNum());
				rowx.add(employee.getFullName());
				//get the position
					Position pos = new Position();
					String position ="";
							try{
								pos = PstPosition.fetchExc(employee.getPositionId());
								position = pos.getPosition();
							}
							catch(Exception e){
							}
				rowx.add(""+position);
				rowx.add(""+Formater.formatDate(employee.getCommencingDate(),"dd-MMM-yyyy"));
				rowx.add("<input type=\"hidden\" name=\"level_code\" value=\""+payEmpLevel.getLevelCode()+"\" class=\"formElemen\" size=\"10\">"+payEmpLevel.getLevelCode());
				rowx.add(""+payEmpLevel.getStartDate());
			lstData.add(rowx);
			result = ctrlist.drawList();
		}
		}else{
			result = "<i>Belum ada data dalam sistem ...</i>";
		}
	return result;
}
%>
<%
	String s_employee_id = null;
	String s_payslip_id = null;
	String s_level_code = null;
	long  oidEmployee=0;
	// Jika tekan command Save
    if (iCommand == Command.PRINT) {
		if(aksiCommand==0){
			String[] employee_id = null;
			String[] paySlip_id = null;
			String[] level_code = null;
			String hostIpIdx ="";
			Vector listDfGjPrintBenefit = new Vector(1,1);
			Vector listDfGjPrintDeduction = new Vector(1,1);
			try {
				employee_id = request.getParameterValues("employeeId");
				paySlip_id = request.getParameterValues("paySlipId");
				level_code = request.getParameterValues("level_code");
				hostIpIdx = request.getParameter("printeridx");// ip server				
			 }catch (Exception e){
				System.out.println("Err : "+e.toString());
			}
			
			DSJ_PrintObj obj = null;
			Vector list = new Vector();
			for (int i = 0; i < listEmpPaySlip.size(); i++) 
			{
				listDfGjPrintBenefit = new Vector();
				try{
					   s_employee_id = String.valueOf(employee_id[i]);
					   s_payslip_id = String.valueOf(paySlip_id[i]);
					   s_level_code = String.valueOf(level_code[i]);
					 } catch (Exception e){}
					
					listDfGjPrintBenefit = PstSalaryLevelDetail.listPaySlipGlobal(PstSalaryLevelDetail.YES_TAKE,s_level_code,Long.parseLong(paySlip_id[i]),keyPeriod);
					list.add(listDfGjPrintBenefit);
					
			}
			if(hostIpIdx!=null){
				obj = PrintPaySlip.PrintForm(employee_id,periodeId,list,listEmpPaySlip,keyPeriod);
				PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx,";");
				PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx,";");
				obj.setPrnIndex(prn.getPrnIndex());
				RemotePrintMan.printObj(prnHost,obj);
			}
		}
		else{
			System.out.println("print selected");
			String[] employee_id = null;
			String[] paySlip_id = null;
			String[] level_code = null;
			String hostIpIdx ="";
			Vector listDfGjPrintBenefit = new Vector(1,1);
			try {
				employee_id = request.getParameterValues("employeeId");
				paySlip_id = request.getParameterValues("paySlipId");
				level_code = request.getParameterValues("level_code");
				hostIpIdx = request.getParameter("printeridx");// ip server				
			 }catch (Exception e){
				System.out.println("Err : "+e.toString());
			}
			DSJ_PrintObj obj = null;
			Vector list = new Vector();
			Vector listEmp = new Vector();
			for (int i = 0; i < listEmpPaySlip.size(); i++){
				listDfGjPrintBenefit = new Vector();
					try{
					   oidEmployee = FRMQueryString.requestLong(request, "print"+i+""); // row yang dicheked
					   s_employee_id = String.valueOf(employee_id[i]);
					   s_payslip_id = String.valueOf(paySlip_id[i]);
					   s_level_code = String.valueOf(level_code[i]);
					 }catch(Exception e){}
					
					if(oidEmployee!=0){
						listDfGjPrintBenefit = PstSalaryLevelDetail.listPaySlipGlobal(PstSalaryLevelDetail.YES_TAKE,s_level_code,Long.parseLong(paySlip_id[i]),keyPeriod);
						list.add(listDfGjPrintBenefit);
						listEmp.add(""+oidEmployee);
					}
			}
			
			if(hostIpIdx!=null){
				obj = PrintPaySlip.PrintForm(employee_id,periodeId,list,listEmp,keyPeriod);
				PrinterHost prnHost = RemotePrintMan.getPrinterHost(hostIpIdx,";");
				PrnConfig prn = RemotePrintMan.getPrinterConfig(hostIpIdx,";");
				obj.setPrnIndex(prn.getPrnIndex());
				RemotePrintMan.printObj(prnHost,obj);
			}
			
		}
		listEmpPaySlip = SessEmployee.listEmpPaySlip(oidDepartment,oidDivision,oidSection,searchNrFrom,searchNrTo,searchName,periodeId);			
	}
%>

<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>HARISMA - </title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "styles" --> 
<link rel="stylesheet" href="../../styles/main.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "stylestab" --> 
<link rel="stylesheet" href="../../styles/tab.css" type="text/css">
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
	
function fnTrapKD(){
   if (event.keyCode == 13) {
		document.all.aSearch.focus();
		cmdSearch();
   }
}

function cmdSearch(){
	document.frm_printing.command.value="<%=Command.LIST%>";
	document.frm_printing.action="pay-printing.jsp";
	document.frm_printing.submit();
}

function cmdLoad(component_code,component_name){
	document.frm_prepare_data.compCode.value=component_code;
	document.frm_prepare_data.compName.value=component_name;
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
	document.frm_prepare_data.submit();
	document.frm_prepare_data.refresh;
}

function cmdLevel(employeeId,salaryLevel,paySlipId,paySlipPeriod){
	document.frm_prepare_data.action="pay-input-detail.jsp?employeeId=" + employeeId+ "&salaryLevel=" + salaryLevel+"&paySlipId=" + paySlipId +"&paySlipPeriod=" + paySlipPeriod ;
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.submit();
}

function cmdSave(){
	document.frm_prepare_data.command.value="<%=Command.SAVE%>";
	document.frm_prepare_data.aksiCommand.value="0";
	document.frm_prepare_data.statusSave.value="0";
	document.frm_prepare_data.action="pay-pre-data.jsp";
	document.frm_prepare_data.submit();
}
function cmdPrint(){
	document.frm_printing.command.value="<%=Command.PRINT%>";
	document.frm_printing.aksiCommand.value="1";
	document.frm_printing.action="pay-printing.jsp";
	document.frm_printing.submit();
}

function cmdPrintAll(){
	document.frm_printing.command.value="<%=Command.PRINT%>";
	document.frm_printing.aksiCommand.value="0";
	document.frm_printing.action="pay-printing.jsp";
	document.frm_printing.submit();
}
function cmdSaveAll(){
	document.frm_prepare_data.command.value="<%=Command.SAVE%>";
	document.frm_prepare_data.aksiCommand.value="0";
	document.frm_prepare_data.statusSave.value="1";
	document.frm_prepare_data.action="pay-pre-data.jsp";
	document.frm_prepare_data.submit();
}

function cmdBack(){
	document.frm_prepare_data.command.value="<%=Command.LIST%>";
	document.frm_prepare_data.action="pay-pre-data.jsp";
	document.frm_prepare_data.submit();
}

    function hideObjectForEmployee(){
        
    } 
	 
    function hideObjectForLockers(){ 
    }
	
    function hideObjectForCanteen(){
    }
	
    function hideObjectForClinic(){
    }

    function hideObjectForMasterdata(){
    }
	
	function showObjectForMenu(){
        
    }
</SCRIPT>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF" >
  <tr> 
    <td ID="TOPTITLE" background="<%=approot%>/images/HRIS_HeaderBg3.jpg" width="100%" height="54"> 
      <!-- #BeginEditable "header" --> 
      <%@ include file = "../../main/header.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
  <tr> 
    <td  bgcolor="#9BC1FF" height="15" ID="MAINMENU" valign="middle"> <!-- #BeginEditable "menumain" --> 
      <%@ include file = "../../main/mnmain.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
  <tr> 
    <td  bgcolor="#9BC1FF" height="10" valign="middle"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="left"><img src="<%=approot%>/images/harismaMenuLeft1.jpg" width="8" height="8"></td>
          <td align="center" background="<%=approot%>/images/harismaMenuLine1.jpg" width="100%"><img src="<%=approot%>/images/harismaMenuLine1.jpg" width="8" height="8"></td>
          <td align="right"><img src="<%=approot%>/images/harismaMenuRight1.jpg" width="8" height="8"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="3" cellpadding="2">
        <tr> 
          <td width="100%"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="20"> <font color="#FF6600" face="Arial"><strong> <!-- #BeginEditable "contenttitle" -->Pay Slip
                  Printing <!-- #EndEditable --> </strong></font> </td>
              </tr>
              <tr> 
                <td> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="tablecolor"> 
                        <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecolor">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tabbg">
                                <tr> 
                                  <td valign="top"> <!-- #BeginEditable "content" --> 
                                    <form name="frm_printing" method="post" action="">
									<input type="hidden" name="command" value="">
									 <input type="hidden" name="aksiCommand" value="<%=aksiCommand%>">
									  <%
										Vector hostLst = null;
										try{
												//System.out.println(" JSP 1 0");
												 hostLst = RemotePrintMan.getHostList();
												 //System.out.println(" JSP 1 1");
												if(hostLst!=null){
												   for(int h=0;h<hostLst.size();h++){
														PrinterHost host = (PrinterHost )hostLst.get(h);
													//System.out.println(" JSP 1 2"+h);
														if(host!=null){
															  //out.println(""+h+")"+host.getHostName()+"<br>");
															}
												   }
												}
												}catch(Exception exc){
												  System.out.println("HostLst:  "+exc);
												}
											//out.println("hostLst :::::::::::::"+hostLst);
												
										%>
										
								     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td height="13" width="1%">&nbsp;</td>
                                          <td height="13" width="33%" nowrap><b class="listtitle"><font size="3" color="#000000">Period</font></b> &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;:
                                            <%
                                          Vector periodValue = new Vector(1,1);
										  Vector periodKey = new Vector(1,1);
										 // salkey.add(" ALL DEPARTMET");
										  //deptValue.add("0");
						                  Vector listPeriod = PstPeriod.list(0, 0, "", "START_DATE");
                                          for(int r=0;r<listPeriod.size();r++){
										  	Period period = (Period)listPeriod.get(r);
											periodValue.add(""+period.getOID());
											periodKey.add(period.getPeriod());
										  }
										  %> <%=ControlCombo.draw("periodId",null,""+periodeId,periodValue,periodKey,"")%>
											</font></b></td>
                                          <td height="13" width="30%">&nbsp;</td>
                                          <td height="13" width="28%">&nbsp;</td>
                                          <td height="13" width="8%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="30" width="1%">&nbsp;</td>
										
                                          <td height="30" width="33%" nowrap >Division 
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 
                                            <%
													  Vector listDivision = PstDivision.list(0, 0, "", "DIVISION");										  
													  Vector divValue = new Vector(1,1);
													  Vector divKey = new Vector(1,1);
													  divValue.add("0");
                                                      divKey.add("select ..."); 
													  for(int d=0;d<listDivision.size();d++)
													  {
														Division division = (Division)listDivision.get(d);
														divValue.add(""+division.getOID());
														divKey.add(division.getDivision());										  
													  }
													  out.println(ControlCombo.draw("division",null,""+oidDivision,divValue,divKey));
                                                     %>
                                          </td>
                                          <td height="30" width="40%">Dept 
                                            : 
                                            <% 
                                                            Vector dept_value = new Vector(1,1);
                                                            Vector dept_key = new Vector(1,1);        
															dept_value.add("0");
                                                            dept_key.add("select ...");                                                          
                                                            Vector listDept = PstDepartment.list(0, 0, "", " DEPARTMENT ");                                                        
                                                            for (int i = 0; i < listDept.size(); i++) {
                                                                    Department dept = (Department) listDept.get(i);
                                                                    dept_key.add(dept.getDepartment());
                                                                    dept_value.add(String.valueOf(dept.getOID()));
                                                            }
														out.println(ControlCombo.draw("department",null,""+oidDepartment,dept_value,dept_key));
												%>
                                          </td>
                                          <td height="30" width="28%">Section 
                                            <% 
                                                            Vector sec_value = new Vector(1,1);
                                                            Vector sec_key = new Vector(1,1); 
															sec_value.add("0");
                                                            sec_key.add("select ...");
                                                            //Vector listSec = PstSection.list(0, 0, "", " DEPARTMENT_ID, SECTION ");
															Vector listSec = PstSection.list(0, 0, "", " SECTION ");
                                                            for (int i = 0; i < listSec.size(); i++) {
                                                                    Section sec = (Section) listSec.get(i);
                                                                    sec_key.add(sec.getSection());
                                                                    sec_value.add(String.valueOf(sec.getOID()));
                                                            }
															out.println(ControlCombo.draw("section",null,""+oidSection,sec_value,sec_key));
												%>
                                          </td>
                                          <td height="30" width="8%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="32" width="1%">&nbsp;</td>
                                          <td height="32" width="33%" nowrap>Employee.Nr 
                                            : 
                                            <input type="text" name="searchNrFrom" size="12" value="<%=searchNrFrom%>">
                                            to 
                                            <input type="text" name="searchNrTo" size="12" value="<%=searchNrTo%>">
                                          </td>
                                          <td height="32" width="30%">Name 
                                            <input type="text" name="searchName" size="20" value="<%=searchName%>">
                                          </td>
                                          
                                          <td height="32" width="8%">&nbsp;</td>
                                        </tr>
                                        
                                        <tr> 
											<td>&nbsp;</td>
                                          <td width="33%"><img name="Image10" border="0" src="<%=approot%>/images/BtnSearch.jpg" width="24" height="24" alt="Search Employee"></a>
                                          <img src="<%=approot%>/images/spacer.gif" width="6" height="1">
                                          <a href="javascript:cmdSearch()">Search 
                                           for Employee</a></td></tr>
                                        <tr> 
                                          <td height="13" width="1%">&nbsp;</td>
                                          <td height="13" colspan="4">&nbsp;</td>
                                        </tr>
										<%
											if((listEmpPaySlip!=null)&&(listEmpPaySlip.size()>0)){
										%>
										 <tr> 
                                          <td height="13" width="1%" colspan="2"><b>Pay Slip Period</b>&nbsp;&nbsp;
										  <%
											//value for period
											Vector perKey = new Vector();
											Vector perValue = new Vector();
											perKey.add(PstSalaryLevelDetail.PERIODE_WEEKLY+"");
											perKey.add(PstSalaryLevelDetail.PERIODE_MONTHLY+"");
											perKey.add(PstSalaryLevelDetail.PERIODE_YEAR+"");
											perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_WEEKLY]);
											perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_MONTHLY]);
											perValue.add(PstSalaryLevelDetail.periodKey[PstSalaryLevelDetail.PERIODE_YEAR]);
											out.println(ControlCombo.draw("paySlipPeriod",null,""+keyPeriod,perKey,perValue));
										%>
										  </td>
										<td colspan="2">
											<b>Select Printer: </b>
                                            <select  name="printeridx">
                                              <%
												Vector prnLst = null;
												PrinterHost host = null;
												if(hostLst!=null){
													for(int h = 0; h< hostLst.size();h++){
														try{
															host = (PrinterHost )hostLst.get(h);
															if(host!=null)
																prnLst = host.getListOfPrinters(false);
															if(prnLst!=null){
																for(int i = 0; i< prnLst.size();i++){
																	try{
																		PrnConfig prnConf= (PrnConfig) prnLst.get(i);
																		out.print(" <option value='"+ host.getHostIP()+";"+prnConf.getPrnIndex()+"'> ");
																		out.println(host.getHostName()+ " / " + prnConf.getPrnIndex()+ " "+prnConf.getPrnName()+" "+prnConf.getPrnPort());
																		out.print(" </option>");
																	} catch (Exception exc){out.println("ERROR "+ exc);}
																}
															}
														} catch (Exception exc1){out.println("ERROR" + exc1);}
													}
												}
												
												%>
                                            </select>
										</td>
										
                                        </tr>
										<%
										}
										%>
										
                                        <%
										  //System.out.println("listPreData  "+listPreData.size());
										  if((listEmpPaySlip!=null)&&(listEmpPaySlip.size()>0)){
										  %>
                                        <tr> 
											  <td colspan="6" height="8"><%=drawList(iCommand,frmPaySlipComp, paySlipComp,listEmpPaySlip, oidPaySlipComp,codeComponenGeneral,compName)%></td>
											</tr>
											<%}else{%>
											<tr> 
											<td>&nbsp;  </td>
                                          <td height="8" width="33%" class="comment"><span class="comment"><br>
                                            &nbsp;No Employee available</span> 
                                          </td>
                                        </tr>
										 <%}%>
                                        <tr> 
										  <td colspan="2">
										  <% //if(compCode!=""){%>
										  <!-- Untuk selected printing -->
										  	<img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print Selected">
											<img src="<%=approot%>/images/spacer.gif" width="6" height="1">
											 <a href="javascript:cmdPrint()" class="command">Print Selected</a> &nbsp;&nbsp; &nbsp;&nbsp;
											</td>
											<td colspan="2">
	  	  									<!--Untuk print all -->
                                            <img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Print All">
											<img src="<%//=approot%>/images/spacer.gif" width="6" height="1">
											 <a href="javascript:cmdPrintAll()" class="command">Print All</a> &nbsp;&nbsp; &nbsp;&nbsp;
											 <!--
											 <a href="javascript:cmdSaveAll()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnSave.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnSave.jpg" width="24" height="24" alt="Save All Data"></a>
											  <img src="<%//=approot%>/images/spacer.gif" width="6" height="1">
											 <a href="javascript:cmdSaveAll()" class="command">Save & Approve All</a> &nbsp;&nbsp; &nbsp;&nbsp;
											 -->
											
											 </td>
										  <%//}%>
                                        </tr>
                                        <tr> 
                                          <td class="listtitle" width="1%">&nbsp;</td>
                                          <td class="listtitle" colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="1%">
										  										</td>
                                          <td colspan="4">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td width="1%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="1%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="1%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="1%">&nbsp;</td>
                                          <td colspan="4">&nbsp;</td>
                                        </tr>
                                      </table>
									 

                                    </form>
                                    <!-- #EndEditable --> </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td>&nbsp; </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" bgcolor="#9BC1FF"> <!-- #BeginEditable "footer" --> 
      <%@ include file = "../../main/footer.jsp" %>
      <!-- #EndEditable --> </td>
  </tr>
</table>
</body>
<!-- #BeginEditable "script" --> 
<script language="JavaScript">
	var oBody = document.body;
	var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
</script>
<!-- #EndEditable --> <!-- #EndTemplate -->
</html>
