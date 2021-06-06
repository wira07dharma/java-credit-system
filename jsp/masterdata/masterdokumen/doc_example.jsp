<%-- 
    Document   : doc_example
    Created on : 20-Dec-2017, 13:31:19
    Author     : Gunadi
--%>

<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.common.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocField"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocField"%>
<%@page import="com.dimata.harisma.entity.masterdata.ObjectDocumentDetail"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterTemplate"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMaster"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../../main/javainit.jsp" %>
<%!
    public String docNumber(HttpServletRequest request, long docMasterId){
        String data = "";
        String docNumber = "";
        DocMaster docMaster = new DocMaster();
           try {
               docMaster = PstDocMaster.fetchExc(docMasterId);
           } catch (Exception exc) {}
        
        if (!(docMaster.getDoc_number().equals(""))){
            docNumber = docMaster.getDoc_number();
            String[] docNumArray = docMaster.getDoc_number().split("/");
            for (int i = 0; i < docNumArray.length; i++) {
                String element = docNumArray[i];
                if (element.equals("NUMBER")){
                    String whereDocMaster = PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID] + " = " + docMasterId;
                    Vector listEmpDoc = PstEmpDoc.list(0, 0, whereDocMaster, "");
                    if (listEmpDoc != null && listEmpDoc.size() > 0){
                        int number = 0;
                        for (int x = 0; x < listEmpDoc.size() ; x++){
                            EmpDoc empDocNumber = (EmpDoc) listEmpDoc.get(x);
                            String[] docNumArray1 = empDocNumber.getDoc_number().split("/");
                            number = Integer.valueOf(docNumArray1[i]) + 1;
                        }
                        if (number < 10) {
                            docNumber = docNumber.replaceAll("NUMBER", "0"+number);
                        } else {
                            docNumber = docNumber.replaceAll("NUMBER", ""+number);
                        }    
                    } else {
                        docNumber = docNumber.replaceAll("NUMBER", "01");
                    }
                } else if (element.equals("MM")){
                    Date date = new Date();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int month = cal.get(Calendar.MONTH) + 1;
                    docNumber = docNumber.replaceAll("MM", ""+month);
                } else if (element.equals("YYYY")){
                    Date date = new Date();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int year = cal.get(Calendar.YEAR);
                    docNumber = docNumber.replaceAll("YYYY", ""+year);
                } else if (element.equals("YY")){
                    DateFormat df = new SimpleDateFormat("yy"); // Just the year, with 2 digits
                    String formattedDate = df.format(Calendar.getInstance().getTime());
                    docNumber = docNumber.replaceAll("YY", ""+formattedDate);
                }

            }
        }
        
        data += docNumber;
           
        return data;
    }
%>
<%
    int iCommand = FRMQueryString.requestCommand(request);
    long oidDocMaster = FRMQueryString.requestLong(request, "hidden_docmaster_id");
    long oidDocMasterTemplate = FRMQueryString.requestLong(request, "doc_master_template_oid");
    long oidDoc = 0;
    String empDocMasterTemplateText = "";
    DocMaster empDocMaster1 = new DocMaster();
    long templateId = 0;
    if (oidDocMaster > 0){
            
        try {
            empDocMaster1 = PstDocMaster.fetchExc(oidDocMaster);
        } catch (Exception e){ }

        try {
            empDocMasterTemplateText = PstDocMasterTemplate.getTemplateText(oidDocMaster);
        } catch (Exception e){ }
    } 
    
    
    
    if (iCommand == Command.SAVE){
        String[] objId = FRMQueryString.requestStringValues(request, "FRM_FIELD_OBJECT_ID");
        String[] objName = FRMQueryString.requestStringValues(request, "FRM_FIELD_OBJECT_NAME");
        String[] objClass = FRMQueryString.requestStringValues(request, "FRM_FIELD_CLASS_NAME");
        String[] objType = FRMQueryString.requestStringValues(request, "FRM_FIELD_OBJECT_TYPE");
        String[] objValue = FRMQueryString.requestStringValues(request, "FRM_FIELD_VALUE");

        if (objName != null && objClass != null && objType != null && objValue != null){
            long docMasterId = FRMQueryString.requestLong(request, "hidden_docmaster_id");
            long docId = FRMQueryString.requestLong(request, "FRM_FIELD_DOC_ID");
            String detail = FRMQueryString.requestString(request, "FRM_FIELD_DETAIL");

            String docNumber = docNumber(request, docMasterId);
            Date date = new Date();
            EmpDoc empDoc = new EmpDoc();
            empDoc.setDoc_master_id(docMasterId);
            empDoc.setDoc_title(docNumber);
            empDoc.setDoc_number(docNumber);
            empDoc.setRequest_date(date);
            empDoc.setDate_of_issue(date);
            empDoc.setDetails(detail);
            if (docId > 0){
                try {
                    empDoc.setOID(docId);
                    docId = PstEmpDoc.updateExc(empDoc);
                } catch (Exception exc){

                }
            } else {
                try {
                    docId = PstEmpDoc.insertExc(empDoc);
                } catch (Exception exc){

                }
            }

            if (docId > 0){
                for (int i = 0; i<objValue.length;i++){
                    if (!objValue[i].equals("") || (!objId[i].equals("0") && !objId[i].equals("0"))){
                        EmpDocField docField = new EmpDocField();
                        docField.setEmp_doc_id(docId);
                        docField.setObject_name(objName[i]);
                        docField.setObject_type(Integer.valueOf(objType[i]));
                        docField.setClassName(objClass[i]);
                        docField.setValue(objValue[i]);
                        if (!objId[i].equals("0") && !objId[i].equals("") && !objValue[i].equals("")){
                            try {
                                docField.setOID(Long.valueOf(objId[i]));
                                long oidDocField = PstEmpDocField.updateExc(docField);
                            } catch (Exception exc){}
                        } else if (!objId[i].equals("0") && !objId[i].equals("") && objValue[i].equals("")){
                            try {
                                docField.setOID(Long.valueOf(objId[i]));
                                long oidDocField = PstEmpDocField.deleteExc(Long.valueOf(objId[i]));
                            } catch (Exception exc){}
                        } else {
                            try {
                                long oidDocField = PstEmpDocField.insertExc(docField);
                            } catch (Exception exc){}
                        }
                    }
                }
            }

        } else {
            long docMasterId = FRMQueryString.requestLong(request, "FRM_FIELD_DOC_TEMPLATE_ID");
            long docId = FRMQueryString.requestLong(request, "FRM_FIELD_DOC_ID");
            String detail = FRMQueryString.requestString(request, "FRM_FIELD_DETAIL");

            String docNumber = docNumber(request, docMasterId);
            Date date = new Date();
            EmpDoc empDoc = new EmpDoc();
            empDoc.setDoc_master_id(docMasterId);
            empDoc.setDoc_title(docNumber);
            empDoc.setDoc_number(docNumber);
            empDoc.setRequest_date(date);
            empDoc.setDate_of_issue(date);
            empDoc.setDetails(detail);
            if (docId > 0){
                try {
                    empDoc.setOID(docId);
                    docId = PstEmpDoc.updateExc(empDoc);
                } catch (Exception exc){

                }
            } else {
                try {
                    docId = PstEmpDoc.insertExc(empDoc);
                } catch (Exception exc){

                }
            }
        }
    }
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            input[class="style-4"] {
                border: none;
                border-bottom: solid 1px #c9c9c9;
                transition: border 0.3s;
              }
              .style-4 input[type="text"]:focus,
              .style-4 input[type="text"].focus {
                border-bottom: solid 2px #969696;
              }
              p {
                margin : 1px;
                padding : 0;
                }
            table {
                border-spacing: 2px;
            }
            br {
                display: block;
                margin: 2px;
             }
             
             .containing-element {
                font-size: 5%;
              }
              .inline-block-element {
                display: inline-block;
                
                font-size: 2000%;
                margin-left: -1px;
              }
            
        </style>
        <script type="text/javascript">
            function cmdPrint(oidDocMaster, oidDocMasterTemplate){
                
                var linkPage = "<%=approot%>/AjaxDocument?hidden_docmaster_id="+oidDocMaster+"&doc_master_template_oid="+oidDocMasterTemplate; 
                var newWin = window.open(linkPage,"Leave","height=600,width=950,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes");  			
                newWin.focus();
                
            }
            
            function cmdSave(){
                document.frm.command.value="<%=Command.SAVE%>";
                document.frm.action="doc_example.jsp";
                document.frm.submit();
            }
            
            function cmdBack(){
                document.frm.command.value="<%=Command.EDIT%>";
                document.frm.action="doc_template.jsp";
                document.frm.submit();
            }
        </script>
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css" type="text/css">
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.js"></script>
        
    </head>
    <body>
        <form name="frm" method ="post" action="document.jsp">
            <input type="hidden" name="doc_master_template_oid" value="<%=oidDocMasterTemplate%>">
            <input type="hidden" name="hidden_docmaster_id" value="<%=oidDocMaster%>">
            <input type="hidden" name="command" value="<%=iCommand%>">
        <%
                empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");

                empDocMasterTemplateText = empDocMasterTemplateText.replace("<;", "<");
                empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");
                String tanpaeditor = empDocMasterTemplateText;
                String subString = "";
                String stringResidual = empDocMasterTemplateText;
                Vector vNewString = new Vector();
                
                String imgRoot = "";
                try{
                    imgRoot = PstSystemProperty.getValueByName("COMPANY_NAME");
                }catch (Exception e) {}

                if (!imgRoot.equals("")){
                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${COMPANY}", imgRoot);
                }
                
                String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidDoc + "\"";
                Hashtable hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
                Hashtable hashCompany = new Hashtable();
                Hashtable hashContact = new Hashtable();
                Hashtable hashPinjaman = new Hashtable();
                Hashtable hashContactFamily = new Hashtable();
        
                Vector listCompany = PstCompany.list(0, 0, "", "");
                if (listCompany != null && listCompany.size()>0){
                    try {
                        Company company = (Company) listCompany.get(0);
                        hashCompany = PstCompany.fetchExcHashtable(company.getOID());
                        hashContact = PstAnggota.fetchExcHashtable(576462255181503779L);
                        hashPinjaman = PstPinjaman.fetchExcHashtable(576462264828480028L);
                        hashContactFamily = PstAnggota.fetchExcHashtable(576462263449447080L);
                    } catch (Exception exc){
                        System.out.println(exc.toString());
                    }
                }
                
                int startPosition = 0;
                int endPosition = 0;
                int index=0;
                try {
                    do {

                        ObjectDocumentDetail objectDocumentDetail = new ObjectDocumentDetail();
                        startPosition = stringResidual.indexOf("${") + "${".length();
                        endPosition = stringResidual.indexOf("}", startPosition);
                        subString = stringResidual.substring(startPosition, endPosition);


                        //cek substring


                        String[] parts = subString.split("-");
                        String objectName = "";
                        String objectType = "";
                        String objectClass = "";
                        String objectStatusField = "";
                        try {
                            objectName = parts[0];
                            objectType = parts[1];
                            objectClass = parts[2];
                            objectStatusField = parts[3];
                        } catch (Exception e) {
                            System.out.printf("pastikan 4 parameter");
                        }
                        
                        long oidEmpDocField = 0;
                        String whereC = " "+PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objectName+"\" AND "+PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidDoc+"\"";
                            Vector listEmp = PstEmpDocField.list(0, 0, whereC, ""); 
                            EmpDocField empDocField = new EmpDocField();
                        try {
                            empDocField = (EmpDocField) listEmp.get(0);
                            oidEmpDocField = empDocField.getOID();
                        }catch (Exception e){

                        }


                        //cek dulu apakah hanya object name atau tidak
                        if (!objectName.equals("") && !objectType.equals("") && !objectClass.equals("") && !objectStatusField.equals("")) {
                         if (objectType.equals("FIELD") && objectStatusField.equals("AUTO")) {
                                //String field = "<input type=\"text\" name=\""+ subString +"\" value=\"\">";
                                Date newd = new Date();
                                String field = "04/KEP/BPD-PMT/" + newd.getMonth() + "/" + newd.getYear();
                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", field);
                                tanpaeditor = tanpaeditor.replace("${" + subString + "}", field);

                            } else if (objectType.equals("FIELD")) {

                                if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("TEXT"))) {
                                    
                                    String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='"+oidEmpDocField+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='"+objectName+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='"+objectClass+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                                + "<input type='text' name='FRM_FIELD_VALUE' value='" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "") + "' class='style-4' size='20'>";
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
//                                    tanpaeditor = tanpaeditor.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : " "));
                                } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("MINITEXT"))) {
                                    
                                    String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='"+oidEmpDocField+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='"+objectName+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='"+objectClass+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                                + "<input type='text' name='FRM_FIELD_VALUE' value='" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "") + "' class='style-4' size='5'>";
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("LONGTEXT"))) {
                                    
                                    String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='"+oidEmpDocField+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='"+objectName+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='"+objectClass+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                                + "<input type='text' name='FRM_FIELD_VALUE' value='" + (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "") + "' class='style-4' size='100'>";
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.contains("SELECT"))){
                                    String value= ""+hlistEmpDocField.get(objectName);

                                    int startPositionSelect = objectStatusField.indexOf("[") + "[".length();
                                    int endPositionSelect = objectStatusField.indexOf("]", startPositionSelect);
                                    String subStringSelect = objectStatusField.substring(startPositionSelect, endPositionSelect);

                                    String[] arraySelect = subStringSelect.split("/");
                                    
                                    String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='"+oidEmpDocField+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='"+objectName+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='"+objectClass+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                                + "<select name='FRM_FIELD_VALUE'>";
                                                if (arraySelect.length > 0){
                                                    for (int s=0; s < arraySelect.length;s++){
                                                        if (arraySelect[s].equals(value)){
                                                            add += "<option value='"+arraySelect[s]+"' selected='selected'>"+arraySelect[s]+"</option>";
                                                        } else {
                                                            add += "<option value='"+arraySelect[s]+"'>"+arraySelect[s]+"</option>";
                                                        }
                                                    }
                                                }
                                                add+= "</select>";
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                } else if (objectClass.equals("SYSPROP")){
                                    String value="-";
                                    try {
                                        value = PstSystemProperty.getValueByName(objectStatusField);
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + value);
                                } else if (objectClass.equals("COMPANY")){
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashCompany.get(objectStatusField));
                                } else if (objectClass.equals("CONTACT")){
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashContact.get(objectStatusField));
                                } else if (objectClass.equals("CONTACT_FAMILY")){
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashContactFamily.get(objectStatusField));
                                } else if (objectClass.equals("SELECTION")){
                                    if ((objectStatusField.equals("CONTACT"))){
                                        
                                        Vector con_key = new Vector(1,1);
                                        Vector con_val = new Vector(1,1);
                                        Vector listContact = PstContactList.list(0, 0, "", "");
                                        if (listContact != null && listContact.size() > 0){
                                            for (int i=0; i <listContact.size(); i++){
                                                ContactList contactList = (ContactList) listContact.get(i);
                                                con_key.add(contactList.getPersonName());
                                                con_val.add(String.valueOf(contactList.getOID()));
                                            }
                                        }
                                        String add = "<input type='hidden' name='FRM_FIELD_OBJECT_ID' value='"+oidEmpDocField+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_NAME' value='"+objectName+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_CLASS_NAME' value='"+objectClass+"'>"
                                                + "<input type='hidden' name='FRM_FIELD_OBJECT_TYPE' value='0'>"
                                                + ControlCombo.draw("FRM_FIELD_VALUE", null, "" + hlistEmpDocField.get(objectName), con_val, con_key, "class='select2'");
                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", add);
                                    }
                                } else if (objectClass.equals("KREDIT")){
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashPinjaman.get(objectStatusField));
                                }
                            } else if (objectType.equals("RP")) {
                                if (objectClass.equals("KREDIT")){
                                    String value = "" + hashPinjaman.get(objectStatusField);
                                    String angka = "";
                                    try {
                                        angka = Formater.formatNumber(Double.valueOf(value), "");
                                    } catch (Exception exc){
                                        System.out.println("Exception at RP");
                                    }
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Rp." + angka+",-");
                                }
                            } else if (objectType.equals("TERBILANGRP")) {
                                if (objectClass.equals("KREDIT")){
                                    String value =""+ hashPinjaman.get(objectStatusField);
                                    double nilai = 0;
                                    try {
                                        nilai = Double.valueOf(""+hashPinjaman.get(objectStatusField));
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    
                                    long longTotal = (long) (nilai);
                                    String output = "";
                                    if (longTotal == 0) {
                                        output = "Nol rupiah";
                                    } else if (longTotal < 0) {
                                        longTotal *= -1;
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = "Minus " + convert.getText() + " rupiah";
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    } else {
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = convert.getText() + " rupiah";
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    }
                                    
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);
                                    
                                }
                            } else if (objectType.equals("TERBILANG")) {
                                if (objectClass.equals("KREDIT")){
                                    String value =""+ hashPinjaman.get(objectStatusField);
                                    double nilai = 0;
                                    try {
                                        nilai = Double.valueOf(""+hashPinjaman.get(objectStatusField));
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    
                                    long longTotal = (long) (nilai);
                                    String output = "";
                                    if (longTotal == 0) {
                                        output = "Nol ";
                                    } else if (longTotal < 0) {
                                        longTotal *= -1;
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = "Minus " + convert.getText();
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    } else {
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = convert.getText();
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    }
                                    
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);
                                    
                                }
                            } else if (objectType.equals("TANGGAL")) {
                                if (objectClass.equals("KREDIT")){
                                    String dateShow = "-";
                                    if (hashPinjaman.get(objectStatusField) != null) {
                                        SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                        String dateInString = ""+ hashPinjaman.get(objectStatusField);

                                        SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                        try {
                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                            Date dateX = formatterDateSql.parse(dateInString);
                                            String strDate = sdf.format(dateX);
                                            String strYear = strDate.substring(0, 4);
                                            String strMonth = strDate.substring(5, 7);
                                            if (strMonth.length() > 0){
                                                switch(Integer.valueOf(strMonth)){
                                                    case 1: strMonth = "Januari"; break;
                                                    case 2: strMonth = "Februari"; break;
                                                    case 3: strMonth = "Maret"; break;
                                                    case 4: strMonth = "April"; break;
                                                    case 5: strMonth = "Mei"; break;
                                                    case 6: strMonth = "Juni"; break;
                                                    case 7: strMonth = "Juli"; break;
                                                    case 8: strMonth = "Agustus"; break;
                                                    case 9: strMonth = "September"; break;
                                                    case 10: strMonth = "Oktober"; break;
                                                    case 11: strMonth = "November"; break;
                                                    case 12: strMonth = "Desember"; break;
                                                }
                                            }
                                            String strDay = strDate.substring(8, 10);
                                            dateShow = strDay + " "+ strMonth + " " + strYear;  ////formatterDate.format(dateX);

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + dateShow);
                                }
                            } else if (objectType.equals("HARI")) {
                                String[] stDays = {
                                        "Minggu","Senin","Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"
                                    };
                                if (objectClass.equals("KREDIT")){
                                    String day = "-";
                                    try {
                                        String value=""+hashPinjaman.get(objectStatusField);
                                        DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                                        Date result =  df.parse(value);
                                        Calendar objCal = Calendar.getInstance();
                                        objCal.setTime(result);
                                        day = stDays[objCal.get(Calendar.DAY_OF_WEEK)-1];
                                    } catch (Exception exc){
                                        System.out.println("Exception on PENGAJUAN_DAY");
                                    }
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + day);
                                }
                            } else if (objectType.equals("DD")) {
                                if (objectClass.equals("KREDIT")){
                                    String strDay = "-";
                                    if (hashPinjaman.get(objectStatusField) != null) {
                                        SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                        String dateInString = ""+ hashPinjaman.get(objectStatusField);

                                        SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                        try {
                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                            Date dateX = formatterDateSql.parse(dateInString);
                                            String strDate = sdf.format(dateX);
                                            strDay = strDate.substring(8, 10);

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + strDay);
                                }
                            } else if (objectType.equals("DD_TERBILANG")) {
                                if (objectClass.equals("KREDIT")){
                                    String strDay = "-";
                                    if (hashPinjaman.get(objectStatusField) != null) {
                                        SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                        String dateInString = ""+ hashPinjaman.get(objectStatusField);

                                        SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                        try {
                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                            Date dateX = formatterDateSql.parse(dateInString);
                                            String strDate = sdf.format(dateX);
                                            strDay = strDate.substring(8, 10);

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    
                                    double nilai = 0;
                                    try {
                                        nilai = Double.valueOf(strDay);
                                    } catch (Exception exc){
                                        System.out.println(exc.toString());
                                    }
                                    
                                    long longTotal = (long) (nilai);
                                    String output = "";
                                    if (longTotal == 0) {
                                        output = "Nol ";
                                    } else if (longTotal < 0) {
                                        longTotal *= -1;
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = "Minus " + convert.getText();
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    } else {
                                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                        String con = convert.getText();
                                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                    }
                                    
                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + output);
                                }
                            }

                        } 
                        stringResidual = stringResidual.substring(endPosition, stringResidual.length());
                        objectDocumentDetail.setStartPosition(startPosition);
                        objectDocumentDetail.setEndPosition(endPosition);
                        objectDocumentDetail.setText(subString);
                        vNewString.add(objectDocumentDetail);


                        //mengecek apakah masih ada sisa
                        startPosition = stringResidual.indexOf("${") + "${".length();
                        endPosition = stringResidual.indexOf("}", startPosition);
                        index++;
                    } while (endPosition > 0);
                } catch (Exception e) {
                }

            %>
            <%

                empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");
                empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");

            %>
        <%=empDocMasterTemplateText%>
        <button type="button" onClick="javascript:cmdSave()">Save</button> 
        <button type="button" onClick="javascript:cmdPrint('<%=oidDocMaster%>', '<%=oidDocMasterTemplate%>')">Print</button>
        <button type="button" onClick="javascript:cmdBack()">Back</button>
        </form>
        <script type="text/javascript">
	    $(document).ready(function() {
                $('.select2').select2();
            });
	</script>
    </body>
</html>
