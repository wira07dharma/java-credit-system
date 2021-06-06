<%-- 
    Document   : history_table.jsp
    Created on : Feb 12, 2018, 4:23:05 PM
    Author     : Regen
--%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<% JSONObject jsonObj = (JSONObject) request.getAttribute("obj");%>
<script>
    $(window).load(function () {
        $("#history-table").each(function () {
            var that = $(this);
            var servletName = $(this).data('action');
            var params = $(this).attr('params');
            var dataFor = $(this).data('for');
            var datafilter = "";
            var privUpdate = "";
            var command = 1;
            var dt = $(this).dataTable({
                "responsive": true,
                "bDestroy": true,
                "iDisplayLength": 10,
                "bProcessing": true,
                "bServerSide": true,
                "sAjaxSource": baseUrl(servletName + "?command=" + command + "&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=" + baseUrl() + "&params=" + params),
                "aoColumnDefs": [
                    {
                        bSortable: false,
                        aTargets: [-1]
                    }
                ],
                "oLanguage": {
                    "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>"
                },
                "initComplete": function (settings, json) {

                },
                "fnDrawCallback": function (oSettings) {
                    $(that).find(".money").each(function () {
                        jMoney(this);
                    });
                    (!$(that).data('invoke')) || dataTableInvoker[$(that).data('invoke')](that);
                },
                "fnPageChange": function (oSettings) {

                }
            });
            new $.fn.dataTable.FixedHeader(dt);
        });
    });
</script>
<style>
    #history-table{width: 100% !important}
    #history-table th{background-color: lightgray; color: #333; white-space: nowrap; font-weight: normal; font-size: 14px;}
    #history-table td{font-size: 14px;}
</style>
<table id="history-table" class="table table-bordered" params='<%=(jsonObj != null) ? jsonObj.toString() : ""%>' data-action="ajax/datatable_history.jsp">
    <thead>
        <tr>
            <th style="width: 1%">No.</th>
            <th>Login Name</th>
            <th>User Action</th>
            <th>Date Update</th>
            <th>Document Type</th>
            <th>Detail</th>
        </tr>
    </thead>
    <tbody>
    </tbody>
</table>