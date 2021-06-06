<%@ page language="java" %> 

<%@ page import="java.util.*" %>

<%@ page import="com.dimata.util.*" %>

<%@ page import="com.dimata.gui.jsp.*" %>

<%@ page import="com.dimata.qdep.entity.*" %>

<%@ page import="com.dimata.common.entity.system.*" %>

<%@ page import="com.dimata.qdep.form.*" %>

<%@ page import="com.dimata.common.form.system.*" %>





<%@ include file = "../../main/javainit.jsp" %>

<%

    int iCommand = FRMQueryString.requestCommand(request);

    long lOid = FRMQueryString.requestLong(request, "oid");
    String name = FRMQueryString.requestString(request, "name");
    String note = FRMQueryString.requestString(request, "note");
    //System.out.println("lOid " + lOid);



    CtrlSystemProperty ctrlSystemProperty = new CtrlSystemProperty(request);

    ctrlSystemProperty.action(iCommand, lOid);



    SystemProperty sysProp = ctrlSystemProperty.getSystemProperty();
    if(!name.equals("")){
        sysProp.setName(name);
    }
    if(!note.equals("")){
        sysProp.setNote(note);
    }
    FrmSystemProperty frmSystemProperty = ctrlSystemProperty.getForm();

%>

<html><!-- #BeginTemplate "/Templates/main_s_2.dwt" -->

<head>

<!-- #BeginEditable "doctitle" --> 

<title>hanoman</title>

<!-- #EndEditable -->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "inc_hdscr" --> 

<% //@ include file="../main/hdscript.jsp"%>

<!-- #EndEditable -->

<!-- #BeginEditable "clientscript" --> 



<script language=javascript>

    function cmdSave() {

	  document.frmData.command.value="<%= Command.SAVE %>";          

          document.frmData.oid.value = "<%= lOid %>";

          document.frmData.action = "syspropnew.jsp";

	  document.frmData.submit();

    }



    function cmdEdit() {

	  document.frmData.command.value="<%= Command.EDIT %>";          

          document.frmData.oid.value = "<%= lOid %>";

          document.frmData.action = "syspropnew.jsp";

	  document.frmData.submit();

    }

	

	function cmdAdd() {

	  document.frmData.command.value="<%= Command.ADD %>";          

          document.frmData.oid.value = "0";

          document.frmData.action = "syspropnew.jsp";

	  document.frmData.submit();

    }



    function cmdBack() {

          document.frmData.action = "sysprop_1.jsp";

	  document.frmData.submit();

    }



    function cmdAsk() {

          document.frmData.command.value="<%= Command.ASK %>";          

          document.frmData.action = "syspropnew.jsp";

	  document.frmData.submit();

    }



    function cmdDelete() {

          document.frmData.command.value="<%= Command.DELETE %>";          

          document.frmData.action = "sysprop_1.jsp";

	  document.frmData.submit();

    }



</script>

<link rel="stylesheet" href="../../style/main.css" type="text/css">

<!-- #EndEditable -->





<link rel="stylesheet" href="<%=approot%>/css/default.css" type="text/css">



</head>



<body style="background-color: white" text="#000000" onLoad="MM_preloadImages('<%=approot%>/image/reserv_f2.jpg','<%=approot%>/image/cashiering_f2.jpg','<%=approot%>/image/datamng_f2.jpg','<%=approot%>/image/ledger_f2.jpg','<%=approot%>/image/logout_f2.jpg')" leftmargin="3" topmargin="3">

<table width="100%" border="0" cellpadding="0" cellspacing="0">

  

  <tr> 

    <td colspan="2" valign="top">

	<!-- #BeginEditable "inc_hdr" --> 

      <%//@ include file="../main/header.jsp"%>

      <!-- #EndEditable --> 

	</td> 

  </tr>

  <tr> 

    <td width="100%" height="180" align="center" valign="top">

	<table width="98%" border="0" cellpadding="1" cellspacing="0">

        

        <tr> 

          <td align="center" valign="top" class="frmcontents"><table width="100%" border="0" cellpadding="0" cellspacing="0">

              

              <tr> 

                <td  height="178" align="center" valign="middle" class="contents">

				<table width="100%" border="0" cellspacing="2" cellpadding="2">

				  <tr>

					<td>

					<!-- #BeginEditable "contents" --> 

<form name="frmData" method="post" action=""> 



    <input type="hidden" name="command" value="0">

    <input type="hidden" name="oid" value="0">



              <table width="100%" border="0" cellspacing="6" cellpadding="0">

                <tr align="left" valign="top"> 

                  <td colspan="2"><b>Add New System Property</b></td>

                </tr>

                <tr align="left" valign="top">

                  <td width="13%">&nbsp;</td>

                  <td width="87%" valign="top">&nbsp;</td>

                </tr>

                <tr align="left" valign="top"> 

                  <td width="13%">Property Name</td>

                  <td width="87%" valign="top"> 

                    <input type="text" name="<%= FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_NAME] %>" size="30" maxlength="255" value="<%= sysProp.getName() %>" class="formElemen">

                    * <%= frmSystemProperty.getErrorMsg(frmSystemProperty.FRM_NAME) %> </td>

                </tr>

                <tr align="left" valign="top"> 

                  <td width="13%" height="2">Value Type</td>

                  <td width="87%" height="2" valign="top"> 

                    <%

						String selVal = sysProp.getValueType(); 

						if(selVal == null || selVal.equals("")) selVal = "-- No Value --";

						Vector vct = Validator.toVector(PstSystemProperty.valueTypes);            

						String cbxName = FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_VALTYPE];

						out.println(ControlCombo.draw(cbxName, null, selVal, vct));

					%>

                  </td>

                </tr>

                <tr align="left" valign="top"> 

                  <td width="13%" height="2">Property Group</td>

                  <td width="87%" height="2" valign="top"> 

                    <%

						selVal = sysProp.getGroup(); 

						if(selVal == null || selVal.equals("")) selVal = "-- No Value --";

						Vector grs = Validator.toVector(SessSystemProperty.groups, SessSystemProperty.subGroups, "> ", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ", true);

						Vector val = Validator.toVector(SessSystemProperty.groups, SessSystemProperty.subGroups, "", "", false);

						cbxName = FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_GROUP];

						out.println(ControlCombo.draw(cbxName, "formElemen", null, selVal, val, grs));

			

					%>

                    * <%= frmSystemProperty.getErrorMsg(frmSystemProperty.FRM_GROUP) %> </td>

                </tr>

                <tr align="left" valign="top"> 

                  <td width="13%" height="29">Property Value</td>

                  <td width="87%" height="29" valign="top"> 

                    <input type="text" name="<%= FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_VALUE] %>" size="30" maxlength="255" value="<%= sysProp.getValue() %>" class="formElemen">

                    * <%= frmSystemProperty.getErrorMsg(frmSystemProperty.FRM_VALUE) %> </td>

                </tr>

                <tr align="left" valign="top"> 

                  <td width="13%" height="81">Description</td>

                  <td width="87%" height="81" valign="top"> 
                      <%
                       if((sysProp.getNote()==null || sysProp.getNote().trim().length()< 1)  && (sysProp.getName()==null || sysProp.getName().length()>0 ) ) {
                           sysProp.setNote(SessSystemProperty.getSystemPropsAISONote(sysProp.getName()) );
                       } 
                      %>
                    <textarea name="<%= FrmSystemProperty.fieldNames[FrmSystemProperty.FRM_NOTE] %>" cols="50" rows="2" class="formElemen"><%= sysProp.getNote() %></textarea>

                  </td>

                </tr>

                <tr> 

                  <td colspan="2"> 

                    <%

            ControlLine cln = new ControlLine();
            cln.setSaveStyle("");
            cln.setConfirmDelCommand("javascript:cmdDelete()");

            cln.setDeleteCaption("");

			

            //out.println(cln.drawFrm(iCommand, ctrlSystemProperty.getMsgCode(), ctrlSystemProperty.getMessage()));
            out.println("<a href=\"javascript:cmdSave()\">Save</a> | ");
            out.println("<a href=\"javascript:cmdBack()\">Back</a>");

         %>

                  </td>

                </tr>

                <tr> 

                  <td colspan="2">&nbsp;</td>

                </tr>

                <tr> 

                  <td colspan="2">N O T E : <br>

                    - Use "\\" character when you want to input "\" character 

                    in value field.<br>

                    - Click "Load new value" link when property it's updated. 

                  </td>

                </tr>

              </table>



        </form>

            <!-- #EndEditable --> </td>

				  </tr>

				</table>

                  

                </td>

              </tr>

            </table></td>

        </tr>

      </table></td>

    <td width="1">&nbsp;</td>

  </tr>

  <tr colspan="2">     

    <td>

	<!-- #BeginEditable "inc_ft" --> 

  <%@ include file="../../main/footer.jsp"%>

  <!-- #EndEditable --></td>

  </tr>

</table>

</body>

<!-- #EndTemplate --></html>

