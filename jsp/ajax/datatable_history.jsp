<%@page import="com.dimata.sedana.session.json.SessJSON"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.dimata.qdep.db.DBException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.common.entity.logger.PstLogSysHistory"%>
<%@page import="com.dimata.common.session.datatables.SessDataTables"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%

    String params = request.getParameter("params");
    SessDataTables table = new SessDataTables() {

        //Kolom untuk view.
        @Override
        protected HashMap<String, Integer> columnIndex() {
            HashMap<String, Integer> m = new HashMap<String, Integer>();
            m.put("LOGIN_NAME", 0);
            m.put("USER_ACTION", 1);
            m.put("DOC_TYPE", 2);
            m.put("UPDATE_DATE", 3);
            m.put("DETAIL", 4);
            return m;
        }
    ;

    };
  
  SessDataTables.Column DocumentType = new SessDataTables.Column() {
        {
            this.setColName(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_TYPE]);
            this.setCustom(true);
        }

        @Override
        protected String customAction(ResultSet rs, HashMap<Integer, String> data) throws DBException, SQLException {
            String uri = rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_OPEN_URL]);
            String absolute = uri.equals("#") ? "" : "./../";
            return "<a href='" + absolute + uri + "'>" + rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DOCUMENT_TYPE]) + "</a>";
        }
    };

    SessDataTables.Column detail = new SessDataTables.Column() {
        {
            this.setColName(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DETAIL]);
            this.setCustom(true);
        }

        @Override
        protected String customAction(ResultSet rs, HashMap<Integer, String> data) throws DBException, SQLException {
            String str = rs.getString(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_DETAIL]);
            return SessJSON.deface(str);
        }
    };

    //Nama kolom untuk pencarian database.
    /* 00 */ table.addColumn(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_LOGIN_NAME]);
    /* 03 */ table.addColumn(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_USER_ACTION]);
    /* 01 */ table.addColumn(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_UPDATE_DATE]);
    /* 01 */ table.addColumnCustom(DocumentType);
    /* 02 */ table.addColumnCustom(detail);
    table.setRequest(request);
    table.setResponse(response);
    table.setAdditionalSQLColumn(PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_ID] + " , " + PstLogSysHistory.fieldNames[PstLogSysHistory.FLD_LOG_OPEN_URL]);
    table.setSql(PstLogSysHistory.getHistoryLogQuery(params, "SEDANA"));
    String json = table.generateJSON();
%>

<%=json%>