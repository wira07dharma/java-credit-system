<%-- 
    Document   : doc_relevant_pages
    Created on : Dec 27, 2017, 10:01:09 AM
    Author     : dedy_blinda
--%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.sedana.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@ page import = "com.dimata.sedana.session.SessEmpRelevantDoc" %>
<%@ page import = "com.dimata.aiso.form.masterdata.anggota.*" %>
<%@ page import = "com.dimata.aiso.entity.admin.AppObjInfo" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<!-- Jsp Block -->

<%!
    public static final String tabTitle[][] = {
        {"Data Pribadi", "Anggota Keluarga", "Registrasi Tabungan", "Pendidikan", "Data Tabungan", "Dokumen Bersangkutan"}, {"Personal Date", "Family Member", "Saving Registration", "Education", "Saving Type", "Relevant Document"}
    };
%>

<%!    public String drawList(int command, Vector objectClass, long docRelevantPagesId, long docRelevantId) {
        ControlList ctrlist = new ControlList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("tblStyle");
        ctrlist.setTitleStyle("title_tbl");
        ctrlist.setCellStyle("listgensell");
        ctrlist.setHeaderStyle("title_tbl");
        ctrlist.setCellSpacing("0");
        ctrlist.addHeader("Title", "");
        ctrlist.addHeader("Description", "");
        ctrlist.addHeader("Attach File", "");
        
        if(command != Command.EDIT){
            ctrlist.setLinkRow(0);
        }
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;
        
        Vector rowx = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            EmpRelvtDocPage empRelvtDocPage = (EmpRelvtDocPage) objectClass.get(i);
            rowx = new Vector();
            if (docRelevantPagesId == empRelvtDocPage.getOID()) {
                index = i;
            }
            if(command == Command.EDIT && empRelvtDocPage.getOID() == docRelevantPagesId){
                rowx.add("<input type=\"hidden\" name=\""+FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_DOC_RELEVANT_ID]+"\"  value=\""+empRelvtDocPage.getDocRelevantId()+"\" class=\"formElemen\">"+
                    "<input type=\"text\" name=\""+FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_PAGE_TITLE]+"\"  value=\""+empRelvtDocPage.getPageTitle()+"\" class=\"formElemen\">");
                rowx.add("<textarea name=\""+ FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_PAGE_DESC] +"\" class=\"elemenForm\" cols=\"30\" rows=\"3\">"+empRelvtDocPage.getPageDesc()+"</textarea>");
                rowx.add("<input type=\"hidden\" name=\""+FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_FILE_NAME]+"\"  value=\""+empRelvtDocPage.getFileName()+"\" class=\"formElemen\">"+
                        "<img border=\"0\" src=\"../../images/BtnNew.jpg\" width=\"20\" height=\"20\" ><div  valign =\"top\" align=\"center\"><a style=\"text-decoration:none\" href =\"javascript:cmdAttach('" + empRelvtDocPage.getOID() + "','"+docRelevantId+"')\"><font color=\"#30009D\">Attach File</font></a></div>");
            } else {
                rowx.add(empRelvtDocPage.getPageTitle());
                rowx.add(empRelvtDocPage.getPageDesc());
                rowx.add("<img border=\"0\" src=\"../../images/BtnNew.jpg\" width=\"20\" height=\"20\" ><div  valign =\"top\" align=\"center\"><a style=\"text-decoration:none\" href =\"javascript:cmdAttach('" + empRelvtDocPage.getOID() + "','"+docRelevantId+"')\"><font color=\"#30009D\">Attach File</font></a></div>"+
                        "</br>"+empRelvtDocPage.getFileName());
            }

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(empRelvtDocPage.getOID()));
        }
        rowx = new Vector();
        if(command == Command.ADD){
            rowx.add("<input type=\"hidden\" name=\""+FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_DOC_RELEVANT_ID]+"\"  value=\""+docRelevantId+"\" class=\"formElemen\">"+
                    "<input type=\"text\" name=\""+FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_PAGE_TITLE]+"\"  value=\"\" class=\"formElemen\">");
            rowx.add("<textarea name=\""+ FrmEmpRelvtDocPage.fieldNames[FrmEmpRelvtDocPage.FRM_FIELD_PAGE_DESC] +"\" class=\"elemenForm\" cols=\"30\" rows=\"3\"></textarea>");
            rowx.add("");

            lstData.add(rowx);
        }

        return ctrlist.draw(index);

        //return ctrlist.draw();
    }

%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidEmpRelevantDocPages = FRMQueryString.requestLong(request, "relevant_doc_pages_oid");
    long oidEmpRelevantDoc = FRMQueryString.requestLong(request, "emp_relevant_doc_id");
    
    
    System.out.println("oidEmpRelevantDoc........." + oidEmpRelevantDoc);
    System.out.println("iCommand............." + iCommand);
    /*variable declaration*/
    int recordToGet = 10;
    String msgString = "";
    int iErrCode = FRMMessage.NONE;
    String whereClause = PstEmpRelvtDocPage.fieldNames[PstEmpRelvtDocPage.FLD_DOC_RELEVANT_ID] + " = " + oidEmpRelevantDoc;
    String orderClause = PstEmpRelvtDocPage.fieldNames[PstEmpRelvtDocPage.FLD_PAGE_TITLE];
    String errMsg = "";
    CtrlEmpRelvtDocPage ctrlEmpRelvtDocPage = new CtrlEmpRelvtDocPage(request);
    ControlLine ctrLine = new ControlLine();
    Vector listCtrlEmpRelvtDocPage = new Vector(1, 1);
    
    String currPageTitle = tabTitle[SESS_LANGUAGE][3];
    String strAddMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ADD, true);
    String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_SAVE, true);
    String strAskMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_ASK, true);
    String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_DELETE, true);
    String strBackMar = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_BACK, true) + (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
    String strCancel = ctrLine.getCommand(SESS_LANGUAGE, currPageTitle, ctrLine.CMD_CANCEL, false);
    String delConfirm = (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ") + currPageTitle + " ?";


    /*switch statement */
    iErrCode = ctrlEmpRelvtDocPage.action(iCommand, oidEmpRelevantDocPages);
    /* end switch*/
    FrmEmpRelvtDocPage frmEmpRelvtDocPage = ctrlEmpRelvtDocPage.getForm();

    EmpRelvtDocPage empRelvtDocPage = ctrlEmpRelvtDocPage.getEmpRelvtDocPage();
    msgString = ctrlEmpRelvtDocPage.getMessage();


    /*switch list CareerPath*/
    if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidEmpRelevantDocPages == 0)) {
        start = PstEmpRelvtDocPage.findLimitStart(empRelvtDocPage.getOID(), recordToGet, whereClause, orderClause);
    }

    /*count list All CareerPath*/
    int vectSize = PstEmpRelvtDocPage.getCount(whereClause);

    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlEmpRelvtDocPage.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    /* get record to display */
    listCtrlEmpRelvtDocPage = PstEmpRelvtDocPage.list(start, recordToGet, whereClause, orderClause);

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listCtrlEmpRelvtDocPage.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listCtrlEmpRelvtDocPage = PstEmpRelvtDocPage.list(start, recordToGet, whereClause, orderClause);
    }

    SessEmpRelevantDoc sessEmpRelevantDoc = new SessEmpRelevantDoc();
    String pictPath = "";
    if (iCommand == Command.EDIT || iCommand == Command.ASK) {
        try {
            pictPath = sessEmpRelevantDoc.fetchImageRelevantDoc(oidEmpRelevantDocPages);
        } catch (Exception e) {
            System.out.println("err." + e.toString());
        }
    }
    System.out.println("pictPath .............." + pictPath);

    if (iCommand == Command.SAVE && (iErrCode != FRMMessage.NONE)) {
        iCommand = Command.ADD;
    }


%>
<html><!-- #BeginTemplate "/Templates/maintab.dwt" -->
    <head>
        <!-- #BeginEditable "doctitle" --> 
        <title>Relevant Document </title>
        <script language="JavaScript">
           /* window.onunload = refreshParent;
            function refreshParent() {
                window.opener.location.reload();
            }*/
            function cmdAdd(){
                //document.frm_relevant_doc_pages.emp_relevant_doc_id.value=oidDoc;
            //   alert("tes: "+oidDoc);
                document.frm_relevant_doc_pages.relevant_doc_pages_oid.value="0";
                document.frm_relevant_doc_pages.command.value="<%=Command.ADD%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdAsk(oidEmpRelevantDocPages){
                document.frm_relevant_doc_pages.relevant_doc_pages_oid.value=oidEmpRelevantDocPages;
                document.frm_relevant_doc_pages.command.value="<%=Command.ASK%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdConfirmDelete(oidEmpRelevantDocPages){
                document.frm_relevant_doc_pages.relevant_doc_pages_oid.value=oidEmpRelevantDocPages;
                document.frm_relevant_doc_pages.command.value="<%=Command.DELETE%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }
            function cmdSave(){
                
                document.frm_relevant_doc_pages.command.value="<%=Command.SAVE%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
                self.opener.document.frm_relevant_doc.submit();
                //window.opener.location.reload();
            }

            function cmdEdit(oidEmpRelevantDocPages){
                document.frm_relevant_doc_pages.relevant_doc_pages_oid.value=oidEmpRelevantDocPages;
                document.frm_relevant_doc_pages.command.value="<%=Command.EDIT%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdCancel(oidEmpRelevantDocPages){
                document.frm_relevant_doc_pages.relevant_doc_pages_oid.value=oidEmpRelevantDocPages;
                document.frm_relevant_doc_pages.command.value="<%=Command.EDIT%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdView(oidEmpRelevantDocPages){
                window.open("popup_pict.jsp?command="+<%=Command.EDIT%>+"&emp_relevant_doc_id=" + oidEmpRelevantDocPages , null, "height=700,width=820,status=yes,toolbar=no,menubar=no,location=no,scrollbars=no");

            }

            function cmdOpen(fileName){
                window.open("<%=approot%>/imgdoc/"+fileName , null);
		
            }

            function cmdBack(){
                document.frm_relevant_doc_pages.command.value="<%=Command.BACK%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
               // window.close();
            }

            function cmdListSection(){	
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdUpload(){
                document.frm_relevant_doc_pages.command.value="<%=Command.SAVE%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=prevCommand%>";
                document.frm_relevant_doc_pages.action="upload_relevant_doc.jsp";
                document.frm_relevant_doc_pages.submit();
            }


            function cmdBackEmp(empOID){
                document.frm_relevant_doc_pages.employee_oid.value=empOID;
                document.frm_relevant_doc_pages.command.value="<%=Command.EDIT%>";	
                document.frm_relevant_doc_pages.action="employee_edit.jsp";
                document.frm_relevant_doc_pages.submit();
            }


            function cmdListFirst(){
                document.frm_relevant_doc_pages.command.value="<%=Command.FIRST%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=Command.FIRST%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdListPrev(){
                document.frm_relevant_doc_pages.command.value="<%=Command.PREV%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=Command.PREV%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdListNext(){
                document.frm_relevant_doc_pages.command.value="<%=Command.NEXT%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=Command.NEXT%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdListLast(){
                document.frm_relevant_doc_pages.command.value="<%=Command.LAST%>";
                document.frm_relevant_doc_pages.prev_command.value="<%=Command.LAST%>";
                document.frm_relevant_doc_pages.action="doc_relevant_pages.jsp";
                document.frm_relevant_doc_pages.submit();
            }

            function cmdAttach(empDocPagesId, empDocId){
                //document.frmleavestock.command.value="<!--%=Command.EDIT%-->";
                //document.frm_relevant_doc_pages.hidden_leave_stock_id.value = oid;
                //document.frmleavestock.note_type.value = type;
                //document.frmleavestock.action="leavestock_editor.jsp";
                //document.frmleavestock.submit();

                window.open("upload_pict_pages.jsp?command="+<%=Command.EDIT%>+"&relevant_doc_pages_oid=" + empDocPagesId + "&emp_relevant_doc_id=" + empDocId , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");

            }
        </script>
         <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <!--link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css"-->
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <SCRIPT language=JavaScript>
                <!--
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

                function MM_swapImgRestore() { //v3.0
                    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
                }

                function MM_preloadImages() { //v3.0
                    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
                    }

                    function MM_findObj(n, d) { //v4.0
                        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                        if(!x && document.getElementById) x=document.getElementById(n); return x;
                    }

                    function MM_swapImage() { //v3.0
                        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
                    }
                    //-->
        </SCRIPT>
        <!-- #EndEditable -->
    </head>  

    <body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=approot%>/images/BtnNewOn.jpg')">

        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" bgcolor="#F9FCFF">
            <tr>
                <td>
                    <table>
                        <form name="frm_relevant_doc_pages" method ="post">
                            <input type="hidden" name="command" value="<%=iCommand%>">  
                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                            <input type="hidden" name="start" value="<%=start%>">
                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                            <input type="hidden" name="relevant_doc_pages_oid" value="<%=oidEmpRelevantDocPages%>">
                            <input type="hidden" name="emp_relevant_doc_id" value="<%=oidEmpRelevantDoc%>">

                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td  style="background-color:white"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" >
                                            <tr> 
                                                <td valign="top"> 
                                                    <table style="border:1px solid "   width="100%" border="0" cellspacing="0" cellpadding="0" class="tablecolor">
                                                        <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="3"> 
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="14" valign="middle" colspan="3" class="listedittitle">&nbsp;</td>
                                                                    </tr>
                                                                    <% if (oidEmpRelevantDoc != 0) {
                                                                            EmpRelevantDoc empRelevantDoc = new EmpRelevantDoc();
                                                                            try {
                                                                                empRelevantDoc = PstEmpRelevantDoc.fetchExc(oidEmpRelevantDoc);
                                                                            } catch (Exception exc) {
                                                                                empRelevantDoc = new EmpRelevantDoc();
                                                                            }

                                                                            EmpRelevantDocGroup empRelevantDocGroup = new EmpRelevantDocGroup();
                                                                            try {
                                                                                empRelevantDocGroup = PstEmpRelevantDocGroup.fetchExc(empRelevantDoc.getRelvtDocGrpId());
                                                                            } catch (Exception exc) {
                                                                                empRelevantDocGroup = new EmpRelevantDocGroup();
                                                                            }
                                                                    %>
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="14" valign="middle" colspan="3" class="listedittitle"> 
                                                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                <tr> 
                                                                                    <td width="17%">Doc Group </td>
                                                                                    <td width="2%">:</td>
                                                                                    <td width="81%"><%=empRelevantDocGroup.getDocGroup()%></td>
                                                                                </tr>
                                                                                <tr> 
                                                                                    <td width="17%">Title </td>
                                                                                    <td width="2%">:</td>
                                                                                    <td width="81%"><%=empRelevantDoc.getDocTitle()%></td>
                                                                                </tr>
                                                                                <tr> 
                                                                                    <td width="17%">Document </td>
                                                                                    <td width="2%">:</td>
                                                                                    <td width="81%"><%=empRelevantDoc.getFileName()%></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="14" valign="middle" colspan="3" class="listedittitle">&nbsp;</td>
                                                                    </tr>
                                                                    <%}%>
                                                                    <%
                                                                        try {
                                                                            if (listCtrlEmpRelvtDocPage.size() > 0 || iCommand == Command.ADD) {
                                                                    %>
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="22" valign="middle" colspan="3" class="listtitle"> 
                                                                            &nbsp;Relevant Document List 
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                            <%= drawList(iCommand, listCtrlEmpRelvtDocPage, oidEmpRelevantDocPages, oidEmpRelevantDoc)%> </td>
                                                                    </tr>
                                                                    
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="8" align="left" colspan="3" class="listedittitle"> 
                                                                            <span class="command"> 
                                                                                <%
                                                                                    int cmd = 0;
                                                                                    if ((iCommand == Command.FIRST || iCommand == Command.PREV)
                                                                                            || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
                                                                                        cmd = iCommand;
                                                                                    } else {
                                                                                        if (iCommand == Command.NONE || prevCommand == Command.NONE) {
                                                                                            cmd = Command.FIRST;
                                                                                        } else {
                                                                                            if ((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE) && (oidEmpRelevantDocPages == 0)) {
                                                                                                cmd = PstEmpRelevantDoc.findLimitCommand(start, recordToGet, vectSize);
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                %>
                                                                                <% ctrLine.setLocationImg(approot + "/images");
                                                                                    ctrLine.initDefault();
                                                                                %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                    </tr>
                                                                    
                                                                    <tr align="left" valign="top" > 
                                                                        <td colspan="2" class="command"> 
                                                                          <%

                                                                                                                                        /*ctrLine.setLocationImg(approot + "/image/ctr_line");
                                                                                                                                         ctrLine.initDefault();
                                                                                                                                         ctrLine.setTableWidth("100%");
                                                                                                                                         String scomDel = "javascript:cmdAsk('" + oidEmpRelevantDocPages + "')";
                                                                                                                                         String sconDelCom = "javascript:cmdConfirmDelete('" + oidEmpRelevantDocPages+ "')";
                                                                                                                                         String scancel = "javascript:cmdEdit('" + oidEmpRelevantDocPages + "')";

                                                                                                                                         ctrLine.setCommandStyle("command");
                                                                                                                                         ctrLine.setColCommStyle("command");


                                                                                                                                         ctrLine.setLocationImg(approot+"/images");	*/
                                                                                                                                        ctrLine.initDefault();
                                                                                                                                        ctrLine.setTableWidth("80%");
                                                                                                                                        String scomDel = "javascript:cmdAsk('" + oidEmpRelevantDocPages + "')";
                                                                                                                                        String sconDelCom = "javascript:cmdConfirmDelete('" + oidEmpRelevantDocPages + "')";
                                                                                                                                        String scancel = "javascript:cmdEdit('" + oidEmpRelevantDocPages + "')";
                                                                                                                                        ctrLine.setCommandStyle("command");
                                                                                                                                        ctrLine.setColCommStyle("command");
                                                                                                                                        ctrLine.setAddStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                        ctrLine.setCancelStyle("class=\"btn-delete btn-lg\"");
                                                                                                                                        ctrLine.setDeleteStyle("class=\"btn-delete btn-lg\"");
                                                                                                                                        ctrLine.setBackStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                        ctrLine.setSaveStyle("class=\"btn-save btn-lg\"");
                                                                                                                                        ctrLine.setConfirmStyle("class=\"btn-primary btn-lg\"");
                                                                                                                                        ctrLine.setAddCaption("<i class=\"fa fa-plus-circle\"></i> " + strAddMar);
                                                                                                                                        //ctrLine.setBackCaption("");
                                                                                                                                        ctrLine.setCancelCaption("<i class=\"fa fa-ban\"></i> " + strCancel);
                                                                                                                                        ctrLine.setBackCaption("<i class=\"fa fa-arrow-circle-left\"></i> " + strBackMar);
                                                                                                                                        ctrLine.setSaveCaption("<i class=\"fa fa-save\"></i> " + strSaveMar);
                                                                                                                                        ctrLine.setDeleteCaption("<i class=\"fa fa-trash\"></i> " + strAskMar);
                                                                                                                                        ctrLine.setConfirmDelCaption("<i class=\"fa fa-check-circle\"></i> " + strDeleteMar);

                                                                                                                                        ctrLine.setAddCaption(strAddMar);
                                                                                                                                        ctrLine.setCancelCaption(strCancel);
                                                                                                                                        ctrLine.setBackCaption(strBackMar);
                                                                                                                                        ctrLine.setSaveCaption(strSaveMar);
                                                                                                                                        ctrLine.setDeleteCaption(strAskMar);
                                                                                                                                        ctrLine.setConfirmDelCaption(strDeleteMar);

                                                                                                                                        if (privDelete) {
                                                                                                                                            ctrLine.setConfirmDelCommand(sconDelCom);
                                                                                                                                            ctrLine.setDeleteCommand(scomDel);
                                                                                                                                            ctrLine.setEditCommand(scancel);
                                                                                                                                        } else {
                                                                                                                                            ctrLine.setConfirmDelCaption("");
                                                                                                                                            ctrLine.setDeleteCaption("");
                                                                                                                                            ctrLine.setEditCaption("");
                                                                                                                                        }
                                                                                                                                        if (privAdd == false && privUpdate == false) {
                                                                                                                                            ctrLine.setSaveCaption("");
                                                                                                                                        }
                                                                                                                                        if (privAdd == false) {
                                                                                                                                            ctrLine.setAddCaption("");
                                                                                                                                        }

                                                                                                                                        if (iCommand == Command.EDIT) {
                                                                                                                                            iCommand = Command.EDIT;
                                                                                                                                        }
                                                                                                                                        %> <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> </td>
                                                                      </tr>
                                                                    
                                                                    <%  } else {%>
                                                                    <tr align="left" valign="top"> 
                                                                        <td height="22" valign="middle" colspan="3" class="comment"> 
                                                                            No Relevant Document available 
                                                                        </td>
                                                                    </tr>
                                                                    <% }
                                                                        } catch (Exception exc) {
                                                                        }%>
                                                                    
                                                                    <% if (iCommand != Command.SAVE && listCtrlEmpRelvtDocPage.size() < 2) {%>
                                                                    <tr align="left" valign="top"> 
                                                                        <td> 
                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                <tr> 
                                                                                    <td>&nbsp;</td>
                                                                                </tr>
                                                                               <tr> 
                                                                                    <td width="4" height="25"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                    <td width="24" height="25"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/BtnNew.jpg" width="24" height="24" alt="Add new data"></a></td>
                                                                                    <td width="6" height="25"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                    <td height="25" valign="middle" colspan="3" width="951"><a href="javascript:cmdAdd()" class="command"> 
                                                                                            Add</a> 
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <% 
                                                                        }%>
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
                    </form>
                </td>
            </tr>
        </table>
</body>

<!-- #BeginEditable "script" --> 
<script language="JavaScript">
            var oBody = document.body;
            var oSuccess = oBody.attachEvent('onkeydown',fnTrapKD);
</script>
<!-- #EndEditable --> 
<!-- #EndTemplate --></html>
