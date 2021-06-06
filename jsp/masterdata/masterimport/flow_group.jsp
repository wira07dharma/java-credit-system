<%-- 
    Document   : flow_group
    Created on : 10-Mar-2018, 10:57:27
    Author     : Gunadi
--%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.common.entity.excel.PstFlowGroup"%>
<%@page import="com.dimata.common.entity.excel.FlowGroup"%>
<%@page import="com.dimata.common.form.excel.CtrlFlowGroup"%>
<%@page import="com.dimata.common.form.excel.FrmFlowGroup"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    long oidFlowGroup = FRMQueryString.requestLong(request, "flow_group_id");
    int iCommand = FRMQueryString.requestCommand(request);
    
    CtrlFlowGroup ctrlFlowGroup = new CtrlFlowGroup(request);
    Vector listFlowGroup = new Vector(1,1);
    FrmFlowGroup frmFlowGroup = new FrmFlowGroup();
    frmFlowGroup = ctrlFlowGroup.getForm();
    FlowGroup flowGroup = new FlowGroup();
    int iErrCode = FRMMessage.NONE;
    
    iErrCode = ctrlFlowGroup.action(iCommand, oidFlowGroup);
    
    flowGroup = ctrlFlowGroup.getFlowGroup();
    
    
    
    listFlowGroup = PstFlowGroup.list(0, 0, "", "");
    
%>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript">
            function getCmd(){
                document.form_flowgroup.action = "flow_group.jsp";
                document.form_flowgroup.submit();
            }
            function cmdSave() {
                document.form_flowgroup.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
        </script>
        <script language="javascript">
            $(document).ready(function() {
                $('#btn_add').click(function() {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterimport/flow_group.jsp?flow_group_id=0&command=<%=Command.ADD%>";
                  });
                  
                  $('.btn_edit').click(function() {
                    $(this).attr({"disabled": "true"}).html("....");
                    var oid = $(this).data('oid');
                    window.location = "../masterimport/flow_group.jsp?flow_group_id="+oid+"&command=<%=Command.EDIT%>";
                  });
                  
                  $('.btn_delete').click(function() {
                    var currentHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("...");
                    var confirmTextSingle = "Hapus Data?";
                     if (confirm(confirmTextSingle)) {
                         var oid = ($(this).data('oid'));
                        window.location = "../masterimport/flow_group.jsp?flow_group_id="+oid+"&command=<%=Command.DELETE%>";
                    } else {
                        $(this).removeAttr("disabled").html(currentHtml);
                    }
                  });
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
              Flow Group
              <small></small>
            </h1>
            <ol class="breadcrumb">
              <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
              <li>Master Bumdesa</li>
              <li class="active">Flow Group</li>
            </ol>
        </section>
        
        <section class="content">
            <div class="box box-success">
                <div class="box-body">
                    <label>Daftar Flow Group</label>
                    <table class="table table-bordered table-striped">
                        <tr class="label-success">
                            <th>No.</th>
                            <th>Nama Flow</th>
                            <th>Deskripsi</th>
                            <th>Aksi</th>
                        </tr>
                        <%if (listFlowGroup.isEmpty()) {%>
                        <tr><td colspan="4" class="text-center label-default">Tidak ada data</td></tr>
                        <% } else {
                            for (int i = 0; i < listFlowGroup.size(); i++) {
                                FlowGroup flGroup = (FlowGroup) listFlowGroup.get(i);
                        %>                                                                      
                        <tr>
                            <td><%=(i + 1)%></td>
                            <td><%=flGroup.getFlowGroupName()%></td>
                            <td><%=flGroup.getFlowGroupDescription()%></td>
                            <td class="text-center">
                                <button type="button" title="Ubah Data" class="btn btn-sm btn-warning btn_edit" data-oid="<%=flGroup.getOID()%>"><i class="fa fa-pencil"></i></button>
                                <button type="button" title="Hapus" class="btn btn-sm btn-danger btn_delete" data-oid="<%=flGroup.getOID()%>"><i class="fa fa-trash"></i></button>
                            </td>
                        </tr>
                        <%
                            }
                        }
                        %>
                    </table>
                </div>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Data</button>
                </div>
            </div>
            
            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgrey">                    
                    <h3 class="box-title">Form Input Flow Group</h3>
                </div>
                <p></p>
                
                <form id="form_flowgroup" name="form_flowgroup" class="form-horizontal" method="POST" action="">
                    <input type="hidden" value="<%=oidFlowGroup%>" name="flow_group_id" id="flow_group_id">
                    <input type="hidden" name="command" value="<%=iCommand%>" />
                    <div class="box-body">
                        <div class="col-sm-12">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Nama Flow Group</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" name="<%=FrmFlowGroup.fieldNames[FrmFlowGroup.FRM_FIELD_FLOW_GROUP_NAME]%>" value="<%=flowGroup.getFlowGroupName()%>"  />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Deskripsi</label>
                                    <div class="col-sm-8">
                                        <textarea class="form-control" name="<%=FrmFlowGroup.fieldNames[FrmFlowGroup.FRM_FIELD_FLOW_GROUP_DESCRIPTION]%>"><%=flowGroup.getFlowGroupDescription()%></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box-footer" style="border-color: lightgrey">
                        <div class="form-group" style="margin-bottom: 0px">
                          <div class="col-sm-2"></div>
                          <div class="col-sm-4">
                            <div class="pull-right">
                              <button onclick="cmdSave()" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                              <button type="button" id="" class="btn btn-sm btn-default btn_cancel"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                            </div>
                          </div>
                        </div>
                    </div>
                </form>
            </div>
        <% } %>
        </section>
    </body>
</html>
