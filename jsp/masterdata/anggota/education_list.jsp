<%-- 
    Document   : education_list
    Created on : Feb 22, 2013, 11:19:43 AM
    Author     : HaddyPuutraa
--%>
<%@page language="java" %>

<%@page import="java.util.*" %>
<%@page import="com.dimata.util.*" %>
<%@page import="com.dimata.gui.jsp.*" %>
<%@page import="com.dimata.qdep.form.*" %>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    //Edit by Hadi untuk proses form koperasi
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete=true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

    //if of "hasn't access" condition 
    if(!privView && !privAdd && !privUpdate && !privDelete){
%>
    <script language="javascript">
            window.location="<%=approot%>/nopriv.html";
    </script>
    <!-- if of "has access" condition -->
<%
    }else{
%>
<%! 
    public static final String textListTitle[][] = {
        {"Jenis Pendidikan"},
        {"Education Type"}
    };

    public static final String textListHeader[][] = {
        {"Pendidikan","Diskripsi Pendidikan"},
        {"Education","Education Description"}
    };
    
    public String drawList(int iCommand, FrmEducation frmObject, Education objEntity, Vector objectClass,  long educationId, int languange){
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
        
        //untuk tabel
	ctrlist.addHeader(textListHeader[languange][0],"30%");
	ctrlist.addHeader(textListHeader[languange][1],"70%");

	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Education education = (Education) objectClass.get(i);
            rowx = new Vector();
            if(educationId == education.getOID()){
                index = i;
            }
            if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
                rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[frmObject.FRM_EDUCATION] +"\" value=\""+education.getEducation()+"\" class=\"formElemen\">");
		rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[frmObject.FRM_EDUCATION_DESC] +"\" value=\""+education.getEducationDesc()+"\" class=\"formElemen\">");                                                             
            }else{
		rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(education.getOID())+"')\">"+education.getEducation()+"</a>");
		rowx.add(education.getEducationDesc());					  
            }                         
            lstData.add(rowx); 	
	}

	rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
            rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmEducation.FRM_EDUCATION] +"\" value=\""+objEntity.getEducation()+"\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmEducation.FRM_EDUCATION_DESC] +"\" value=\""+objEntity.getEducationDesc()+"\" class=\"formElemen\">");
	}  
	lstData.add(rowx);

	return ctrlist.draw(index);
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long educationOID = FRMQueryString.requestLong(request, "education_oid");

    // variable declaration
    boolean privManageData = true; 
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = "";
    String orderClause = ""+PstEducation.fieldNames[PstEducation.FLD_EDUCATION];

    /**
    * ControlLine and Commands caption
    */
    ControlLine ctrLine = new ControlLine();
    ctrLine.setLanguage(SESS_LANGUAGE);
    String currPageTitle = textListTitle[SESS_LANGUAGE][0];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
    String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";


    CtrlEducation ctrlEducation = new CtrlEducation(request);
    iErrCode = ctrlEducation.Action(iCommand, educationOID);
    FrmEducation frmEducation = ctrlEducation.getForm();
    Education education = ctrlEducation.getEducation();
    msgString =  ctrlEducation.getMessage();

    //proses mengambil data di tabel
    Vector listEducation = new Vector(1,1);
    int vectSize = PstEducation.getCount(whereClause);
    if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
    {
            start = ctrlEducation.actionList(iCommand, start, vectSize, recordToGet);
    } 

    listEducation = PstEducation.list(start,recordToGet, whereClause , orderClause);
    if (listEducation.size() < 1 && start > 0){
        if (vectSize - recordToGet > recordToGet){
            start = start - recordToGet;  
	}else{
            start = 0 ;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; 
	}
	listEducation = PstEducation.list(start, recordToGet, whereClause , orderClause);
    }
%>
    <!DOCTYPE html>
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <link rel="stylesheet" href="../../style/main.css" type="text/css">
            <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
            <script type="text/javascript" src="../../dtree/dtree.js"></script>
            <title>Education List</title>
            
            <!-- bgin javascript -->
            <script language="JavaScript">
                function cmdAdd(){
                    document.frmEducation.education_oid.value="0";
                    document.frmEducation.command.value="<%=Command.ADD%>";
                    document.frmEducation.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdAsk(educationOID){
                    document.frmEducation.education_oid.value=educationOID;
                    document.frmEducation.command.value="<%=Command.ASK%>";
                    document.frmEducation.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdConfirmDelete(educationOID){
                    document.frmEducation.education_oid.value=educationOID;
                    document.frmEducation.command.value="<%=Command.DELETE%>";
                    document.frmEducation.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdSave(){
                    document.frmEducation.command.value="<%=Command.SAVE%>";
                    document.frmEducatione.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdEdit(educationOID){
                    document.frmEducation.education_oid.value=educationOID;
                    document.frmEducation.command.value="<%=Command.EDIT%>";
                    document.frmEducation.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdCancel(educationOID){
                    document.frmEducation.education_oid.value=educationOID;
                    document.frmEducation.command.value="<%=Command.EDIT%>";
                    document.frmEducation.prev_command.value="<%=prevCommand%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdBack(){
                    document.frmEducation.command.value="<%=Command.BACK%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdListFirst(){
                    document.frmEducation.command.value="<%=Command.FIRST%>";
                    document.frmEducation.prev_command.value="<%=Command.FIRST%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdListPrev(){
                    document.frmEducation.command.value="<%=Command.PREV%>";
                    document.frmEducation.prev_command.value="<%=Command.PREV%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdListNext(){
                    document.frmEducation.command.value="<%=Command.NEXT%>";
                    document.frmEducation.prev_command.value="<%=Command.NEXT%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }

                function cmdListLast(){
                    document.frmEducation.command.value="<%=Command.LAST%>";
                    document.frmEducation.prev_command.value="<%=Command.LAST%>";
                    document.frmEducation.action="education_list.jsp";
                    document.frmEducation.submit();
                }
            </script>
            <!-- #EndEditable -->
        </head>
        <body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
                <tr>
                    <td width="91%" valign="top" align="left" bgcolor="#99CCCC">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                            <tr>
                                <td height="20" class="contenttitle" >&nbsp;
                                    <!-- #BeginEditable "contenttitle" -->Master 
                                    Data &gt; <%=textListTitle[SESS_LANGUAGE][0]%>
                                    <!-- #EndEditable -->
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <form name="frmEducation" method ="post" action="">
                                        <input type="hidden" name="command" value="<%=iCommand%>">
                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                        <input type="hidden" name="start" value="<%=start%>">
                                        <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                        <input type="hidden" name="education_oid" value="<%=educationOID%>">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr align="left" valign="top"> 
                                            <td height="8"  colspan="3"> 
                                              <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                                                <tr align="left" valign="top"> 
                                                  <td height="8" valign="middle" colspan="3">&nbsp; 
                                                  </td>
                                                </tr>
                                                <tr align="left" valign="top"> 
                                                  <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmEducation, education,listEducation,educationOID,SESS_LANGUAGE)%> </td>
                                                </tr>
                                                <tr align="left" valign="top">
                                                  <td height="8" align="left" colspan="3" class="command">
                                                      <% 
                                                        int cmd = 0;
                                                        if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
                                                            cmd =iCommand; 
                                                        }else{
                                                            if(iCommand == Command.NONE || prevCommand == Command.NONE){
                                                                cmd = Command.FIRST;
                                                            }else{
                                                                cmd =prevCommand; 
                                                            }
                                                        } 
                                                     %>
                                                    <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%>
                                                  </td>
                                                </tr>
                                                <tr align="left" valign="top">
                                                  <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                </tr>
                                                <tr align="left" valign="top"> 
                                                  <td height="8" align="left" colspan="3" class="command"> 
                                                    <span class="command">
                                                        <%
                                                            ctrLine.setLocationImg(approot+"/images");						  
                                                            ctrLine.initDefault();
                                                            ctrLine.setTableWidth("80%");
                                                            String scomDel = "javascript:cmdAsk('"+educationOID+"')";
                                                            String sconDelCom = "javascript:cmdConfirmDelete('"+educationOID+"')";
                                                            String scancel = "javascript:cmdEdit('"+educationOID+"')";
                                                            ctrLine.setCommandStyle("command");
                                                            ctrLine.setColCommStyle("command");
                                                            ctrLine.setAddCaption(strAddMar);
                                                            //ctrLine.setBackCaption("");
                                                            ctrLine.setCancelCaption(strCancel);														
                                                            ctrLine.setBackCaption("");														
                                                            ctrLine.setSaveCaption(strSaveMar);
                                                            ctrLine.setDeleteCaption(strAskMar);
                                                            ctrLine.setConfirmDelCaption(strDeleteMar);            

                                                                  if (privDelete){
                                                                          ctrLine.setConfirmDelCommand(sconDelCom);
                                                                          ctrLine.setDeleteCommand(scomDel);
                                                                          ctrLine.setEditCommand(scancel);
                                                                  }else{ 
                                                                          ctrLine.setConfirmDelCaption("");
                                                                          ctrLine.setDeleteCaption("");
                                                                          ctrLine.setEditCaption("");
                                                                  }

                                                                  if(privAdd == false  && privUpdate == false){
                                                                          ctrLine.setSaveCaption("");
                                                                  }

                                                                  if (privAdd == false){
                                                                          ctrLine.setAddCaption("");
                                                                  }

                                                                  if(iCommand == Command.ASK){
                                                                          ctrLine.setDeleteQuestion(delConfirm); 
                                                                  }					
                                                                  out.println(ctrLine.draw(iCommand, iErrCode, msgString));
                                                        %>
                                                    </span>
                                                  </td>
                                                </tr>
                                                <%
                                                    if(privAdd && (iErrCode==ctrlEducation.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmEducation.errorSize()==0) ){ 
                                                %>					  
                                                <tr align="left" valign="top"> 
                                                  <td height="22" valign="middle" colspan="3"> 
                                                    <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>&nbsp;<a href="javascript:cmdAdd()" class="command"><%//=strAddMar%></a></tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <%					  
                                                    }
                                                %>
                                              </table>
                                            </td>
                                          </tr>

                                          <%
                                            if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmEducation.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) ){
                                          %>				
                                            <tr align="left" valign="top" > 
                                              <td colspan="3" class="command">&nbsp;</td>
                                            </tr>
                                          <%
                                            }
                                          %>
                                        </table>
                                    </form>
                                    <%
                                        if(iCommand==Command.ADD || iCommand==Command.EDIT){
                                    %>
                                        <script language="javascript">
                                            document.frmEducation.<%=FrmEducation.fieldNames[FrmEducation.FRM_EDUCATION]%>.focus();
                                        </script>
                                    <%
                                        }
                                    %>
                                    <!-- #EndEditable -->
                                </td> 
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
    </html>
<%
   }
%>
