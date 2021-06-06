<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.aiso.entity.admin.PstAppUser"%>
<%@page import="com.dimata.sedana.entity.masterdata.TellerShift"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.session.datatables.SessDataTables"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    long userLocationId = FRMQueryString.requestLong(request, "USER_LOCATION_ID");
  SessDataTables table = new SessDataTables() {
    
    @Override
    protected HashMap<String, Integer> columnIndex() {
      HashMap<String, Integer> m = new HashMap<String, Integer>();
      m.put("FRM_FLD_OPEN_DATE", 0);
      m.put("FRM_FLD_SPV_OPEN_NAME", 1);
      m.put("FRM_FLD_SPV_CLOSE_NAME", 2);
      m.put("FRM_FLD_CLOSE_DATE", 3);
      m.put("FRM_FLD_STATUS", 4);
      m.put("FRM_FLD_OPENING_VALUE", 5);
      m.put("FRM_FLD_DEBET", 6);
      m.put("FRM_FLD_KREDIT", 7);
      m.put("FRM_FLD_COMPUTED_VALUE", 8);
      m.put("FRM_FLD_COMPUTED_CLOSING_VALUE", 9);
      m.put("FRM_FLD_CLOSING_VALUE", 10);
      m.put("FRM_FLD_SELISIH", 11);
      m.put("FRM_FLD_TELLER_SHIFT_ID", 12);
      return m;
    };
    
    @Override
    protected String action(String rsVal, HashMap<Integer, String> data) {
      String d = "";
      String status = data.get(getColumIndex("FRM_FLD_STATUS"));
      if(status.equals("OPEN")) {
        d += "<div style='text-align:center; width: 60px'>"
                + "<a title='Print opening' class='print-shift' data-print='opening' data-id='"+rsVal+"' href='#'><i class='fa fa-file-o'></i></a>"
                + "&nbsp;&nbsp;"
                + "<a href='#' class='show-closing' data-outside='true' data-id='"+rsVal+"' title='Close shift'><i class='fa fa-check-square-o'></i></a>"
                + "&nbsp;&nbsp;"
                + "<a href='../tellershift/teller_cash_flow.jsp?teller_shift_id="+rsVal+"' title='Modal Teller'><i class='fa fa-file-text-o'></i></a>"
                + "</div>";
      } else {
        d += "<div style='text-align:center'>"
                + "<a title='Print opening' data-print='opening' class='print-shift' data-id='"+rsVal+"' href='#'><i class='fa fa-file-o'></i></a>"
                + "&nbsp;&nbsp;"
                + "<a class='print-shift' data-print='closing' data-computed='"+data.get(getColumIndex("FRM_FLD_COMPUTED_CLOSING_VALUE"))+"' data-id='"+rsVal+"' title='Print closing' href='#'><i class='fa fa-file'></i></a></div>";
      }
      
      return d;
    }
    
  };
  
  /* 00 */ table.addColumn("`OPEN_DATE`", "<nobr>@</nobr>");
  /* 03 */ table.addColumn("`full_name`");
  /* 01 */ table.addColumn("`SPV_OPEN_NAME`");
  /* 02 */ table.addColumn("`SPV_CLOSE_NAME`");
  /* 04 */ table.addColumn("IF(`STATUS` > 2, 'CLOSED', 'OPEN') AS asas");
  /* 05 */ table.addColumn("IFNULL(`OPENING_VALUE`, 0) AS `OPENING_VALUE`", "<div style='text-align:right;' class='money'>@</div>");
  /* 05 */ table.addColumn("IFNULL(`DEBET`, 0) AS `DEBET`", "<div style='text-align:right;' class='money'>@</div>");
  /* 05 */ table.addColumn("IFNULL(`KREDIT`, 0) AS `KREDIT`", "<div style='text-align:right;' class='money'>@</div>");
  /* 06 */ table.addColumn("IFNULL(`COMPUTED_VALUE`, 0) AS `COMPUTED_VALUE`", "<div style='text-align:right;' class='money'>@</div>");
  /* 06 */ table.addColumn("IFNULL(`COMPUTED_CLOSING_VALUE`, 0) AS `COMPUTED_CLOSING_VALUE`", "<div style='text-align:right;' class='money'>@</div>");
  /* 07 */ table.addColumn("IFNULL(`CLOSING_VALUE`, 0) AS `CLOSING_VALUE`", "<div style='text-align:right;' class='money'>@</div>");
  /* 07 */ table.addColumn("IFNULL(`SELISIH`, 0) AS `SELISIH`", "<div style='text-align:right;' class='money'>@</div>");
  /* 08 */ table.addColumnAction("`TELLER_SHIFT_ID`");
  /* 07 */ table.addColumn("ASSIGN_LOCATION_ID");
  table.setRequest(request);
  table.setResponse(response);
  table.setSql(PstCashTeller.getTellerShiftQuery(PstAppUser.fieldNames[PstAppUser.FLD_ASSIGN_LOCATION_ID] + " = " + userLocationId));
  String json = table.generateJSON();
%><%=json%>