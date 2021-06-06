<%-- 
    Document   : doc_header
    Created on : 30-Dec-2017, 10:13:18
    Author     : Gunadi
--%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.util.Command"%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package master -->
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.harisma.entity.masterdata.*"%>
<%@page import="com.dimata.harisma.form.masterdata.*"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDocMasterTemplate = FRMQueryString.requestLong(request, "doc_master_template_oid");
long oidDocMaster = FRMQueryString.requestLong(request, "hidden_docmaster_id");


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";



CtrlDocMasterTemplate ctrlDocMasterTemplate = new CtrlDocMasterTemplate(request);
ControlLine ctrLine = new ControlLine();
Vector listDocMasterTemplate = new Vector(1,1);


/* end switch */
FrmDocMasterTemplate frmDocMasterTemplate = ctrlDocMasterTemplate.getForm();

long sdocmasterId = FRMQueryString.requestLong(request, FrmDocMasterTemplate.fieldNames[FrmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID]);

if (oidDocMaster > 0){
    whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] +" = " + oidDocMaster;
} else {
    whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] +" = " + sdocmasterId;
}
listDocMasterTemplate = PstDocMasterTemplate.list(start,recordToGet, whereClause , orderClause);

DocMasterTemplate docMasterTemplateObj = new DocMasterTemplate();
if (listDocMasterTemplate.size() > 0){
 
    try {
        docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
    } catch (Exception e){
    }
}
oidDocMasterTemplate = docMasterTemplateObj.getOID();
iErrCode = ctrlDocMasterTemplate.action(iCommand , oidDocMasterTemplate);

listDocMasterTemplate = PstDocMasterTemplate.list(start,recordToGet, whereClause , orderClause);

if (listDocMasterTemplate.size() > 0){
 
    try {
        docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
    } catch (Exception e){
    }
}

/*count list All DocMasterTemplate*/
int vectSize = PstDocMasterTemplate.getCount(whereClause);

/*switch list DocMasterTemplate*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlDocMasterTemplate.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

DocMasterTemplate docMasterTemplate = ctrlDocMasterTemplate.getdDocMasterTemplate();
msgString =  ctrlDocMasterTemplate.getMessage();

/* get record to display */

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDocMasterTemplate.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listDocMasterTemplate = PstDocMasterTemplate.list(start,recordToGet, whereClause , orderClause);
}
     if (oidDocMaster > 0){
        docMasterTemplate.setDoc_master_id(oidDocMaster);
    } else {
        docMasterTemplate.setDoc_master_id(sdocmasterId);
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script src="../../style/ckeditor/ckeditor.js"></script>
        <script src="../../style/ckeditor/adapters/jquery.js"></script>
        <title>Accounting Information System Online</title>
        <script type="text/javascript">
            function cmdSave(){
                document.frmDocMasterTemplate.command.value="<%=Command.SAVE%>";
                document.frmDocMasterTemplate.action="doc_header.jsp";
                document.frmDocMasterTemplate.submit();
            }
        </script>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
    </head>
    <body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
       <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
        <tr> 
          <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
              <tr> 
                <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Master 
                  Data &gt; Template <!-- #EndEditable --></td>
              </tr>
              <tr> 
                <td valign="top"><!-- #BeginEditable "content" --> 
                  <form name="frmDocMasterTemplate" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                    <input type="hidden" name="doc_master_template_oid" value="<%=oidDocMasterTemplate%>">
                    <input type="hidden" name="hidden_docmaster_id" value="<%=oidDocMaster%>">
                    <input type="hidden" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID]%>" value="<%=docMasterTemplateObj.getDoc_master_id()%>">
                    <input type="hidden" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_DOC_MASTER_TEMPLATE_ID]%>" value="<%=docMasterTemplateObj.getDoc_master_template_id()%>">
                    <input type="hidden" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEMPLATE_FILE_NAME]%>" value="<%=docMasterTemplateObj.getTemplate_filename()%>">
                    <input type="hidden" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEMPLATE_TITLE]%>" value="<%=docMasterTemplateObj.getTemplate_title()%>">
                    <textarea name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_TEMPLATE]%>" style="display:none;"> <%=docMasterTemplateObj.getText_template()%></textarea>
                    <textarea name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_FOOTER]%>" style="display:none;"><%=docMasterTemplateObj.getText_footer()%></textarea>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8"  colspan="3"> 
                          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; 
                              </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <textarea id="editor1" class="ckeditor" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_HEADER]%>" class="elemenForm" cols="70" rows="40"><%= (docMasterTemplateObj.getText_header() != null ? docMasterTemplateObj.getText_header() : "")%></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                            <tr align="left" valign="top"> 
                                <td height="8" align="left" colspan="3" class="command"> 
                                    <a class="btn-primary btn-sm" style="color:#FFF" href="javascript:cmdSave()"><i class="fa fa-save"></i> Simpan</a> 
                                 </td>
                              </tr>
                              <tr>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </form>
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
        <script type="text/javascript">
          $(function() {
              // Replace the <textarea id="editor1"> with a CKEditor
              // instance, using default configuration.
              CKEDITOR.replace("#editor1",
              {
                   height: 400
              });
              //bootstrap WYSIHTML5 - text editor
              $(".textarea").ckeditor();
          });
          $(document).on('click', '.cke_button__pagebreak', function(){
              var editor_data = CKEDITOR.instances["editor1"].getData();
              CKEDITOR.instances["editor1"].setData(editor_data+"<div class='document-editor'><table style='height:100%; width:100%'><tbody><tr><td style='vertical-align:top'>&nbsp;</td></tr></tbody></table><div>&nbsp;</div></div>");
        });
      </script>
      <script>
        // Need to wait for the ckeditor instance to finish initialization
        // because CKEDITOR.instances.editor.commands is an empty object
        // if you try to use it immediately after CKEDITOR.replace('editor');
        CKEDITOR.on('instanceReady', function (ev) {

            // Create a new command with the desired exec function
            var editor = ev.editor;
            var overridecmd = new CKEDITOR.command(editor, {
                exec: function(editor){
                    // Replace this with your desired save button code
                    var editor_data = CKEDITOR.instances["editor1"].getData();
                    CKEDITOR.instances["editor1"].setData(editor_data+"<div class='document-editor'><table style='height:100%; width:100%'><tbody><tr><td style='vertical-align:top'>&nbsp;</td></tr></tbody></table><div>&nbsp;</div></div>");
                }
            });

            // Replace the old save's exec function with the new one
            ev.editor.commands.newpage.exec = overridecmd.exec;
        });

        CKEDITOR.replace('CKEditor1');

    </script>
    </body>
</html>
