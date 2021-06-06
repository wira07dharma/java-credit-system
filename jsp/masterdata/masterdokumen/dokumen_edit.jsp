<%-- 
    Document   : dokumen_edit
    Created on : 05-Jan-2018, 10:23:06
    Author     : Gunadi
--%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.BiayaTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstBiayaTransaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.AnggotaKeluarga"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggotaKeluarga"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDocField"%>
<%@page import="com.dimata.harisma.entity.masterdata.ObjectDocumentDetail"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.Company"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDocField"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstEmpDoc"%>
<%@page import="com.dimata.harisma.form.masterdata.FrmEmpDoc"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.harisma.form.masterdata.CtrlEmpDoc"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMasterTemplate"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstDocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMaster"%>
<%@page import="com.dimata.harisma.entity.masterdata.DocMasterTemplate"%>
<%@page import="com.dimata.harisma.entity.masterdata.EmpDoc"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@include file="../../main/javainit.jsp" %>

<%!
    public String docNumber(HttpServletRequest request, long docMasterId) {
        String data = "";
        String docNumber = "";
        DocMaster docMaster = new DocMaster();
        try {
            docMaster = PstDocMaster.fetchExc(docMasterId);
        } catch (Exception exc) {
        }

        if (docMaster.getDoc_number() != null) {
            docNumber = docMaster.getDoc_number();
            String[] docNumArray = docMaster.getDoc_number().split("/");
            for (int i = 0; i < docNumArray.length; i++) {
                String element = docNumArray[i];
                if (element.equals("NUMBER")) {
                    String whereDocMaster = PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID] + " = " + docMasterId;
                    Vector listEmpDoc = PstEmpDoc.list(0, 0, whereDocMaster, "");
                    if (listEmpDoc != null && listEmpDoc.size() > 0) {
                        int number = 0;
                        for (int x = 0; x < listEmpDoc.size(); x++) {
                            EmpDoc empDocNumber = (EmpDoc) listEmpDoc.get(x);
                            String[] docNumArray1 = empDocNumber.getDoc_number().split("/");
                            number = Integer.valueOf(docNumArray1[i]) + 1;
                        }
                        if (number < 10) {
                            docNumber = docNumber.replaceAll("NUMBER", "0" + number);
                        } else {
                            docNumber = docNumber.replaceAll("NUMBER", "" + number);
                        }
                    } else {
                        docNumber = docNumber.replaceAll("NUMBER", "01");
                    }
                } else if (element.equals("MM")) {
                    Date date = new Date();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int month = cal.get(Calendar.MONTH) + 1;
                    docNumber = docNumber.replaceAll("MM", "" + month);
                } else if (element.equals("YYYY")) {
                    Date date = new Date();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int year = cal.get(Calendar.YEAR);
                    docNumber = docNumber.replaceAll("YYYY", "" + year);
                } else if (element.equals("YY")) {
                    DateFormat df = new SimpleDateFormat("yy"); // Just the year, with 2 digits
                    String formattedDate = df.format(Calendar.getInstance().getTime());
                    docNumber = docNumber.replaceAll("YY", "" + formattedDate);
                } else if (element.equals("MM-ROMAN")) {
                    Date date = new Date();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int month = cal.get(Calendar.MONTH) + 1;
                    switch (month) {
                        case 1:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "I");
                            break;
                        case 2:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "II");
                            break;
                        case 3:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "III");
                            break;
                        case 4:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "IV");
                            break;
                        case 5:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "V");
                            break;
                        case 6:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "VI");
                            break;
                        case 7:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "VII");
                            break;
                        case 8:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "VII");
                            break;
                        case 9:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "IX");
                            break;
                        case 10:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "X");
                            break;
                        case 11:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "XI");
                            break;
                        case 12:
                            docNumber = docNumber.replaceAll("MM-ROMAN", "XII");
                            break;

                    }
                }

            }
        }

        data += docNumber;

        return data;
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int start = FRMQueryString.requestInt(request, "start");
    int prevCommand = FRMQueryString.requestInt(request, "prev_command");
    long oidEmpDoc = FRMQueryString.requestLong(request, "oid_emp_doc");
    long oidPinjaman = FRMQueryString.requestLong(request, "oid_pinjaman");
    String type = FRMQueryString.requestString(request, "type");
    boolean isGeneratedBefore = false;
    
    
    long oidDocMaster = 0;
    if (type.equals("PK")) {
        try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("PK_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value PK_DOCUMENT_OID");
        }
    } else if (type.equals("SP1")) {
        try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SP1_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SP1_DOCUMENT_OID");
        }
    } else if (type.equals("SP2")) {
        try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SP2_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SP2_DOCUMENT_OID");
        }
    } else if (type.equals("SP3")) {
        try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SP3_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SP3_DOCUMENT_OID");
        }
    } else if (type.equals("SPMK")) {
        try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SPMK_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPMK_DOCUMENT_OID");
        }
    } else if(type.equals("SPKJ")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SPKJ_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
    }
	} else if(type.equals("F5C")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("DOCUMENT_FORM5C_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
        }
	} else if(type.equals("KAS")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("DOCUMENT_KARTU_ANGSURAN_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
        }
	} else if(type.equals("SPT")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("DOCUMENT_SURAT_PERNYATAAN_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
        }
	} else if(type.equals("BAP")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("DOCUMENT_BAP_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
        }
	} else if(type.equals("FDP")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("DOCUMENT_FAKTURDP_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SPKJ_DOCUMENT_OID");
        }
	} else if(type.equals("SRK")){
		try {
            oidDocMaster = Long.valueOf(PstSystemProperty.getValueByName("SRK_DOCUMENT_OID"));
        } catch (Exception exc) {
            System.out.println("Please Set Value SRK_DOCUMENT_OID");
        }
	}

    /*variable declaration*/
    int iErrCode = FRMMessage.NONE;

    EmpDoc empDoc = new EmpDoc();
    DocMaster empDocMaster = new DocMaster();
    Pinjaman pinjaman = new Pinjaman();
    CtrlEmpDoc ctrlEmpDoc = new CtrlEmpDoc(request);
    iErrCode = ctrlEmpDoc.action(iCommand, oidEmpDoc);

    FrmEmpDoc frmEmpDoc = ctrlEmpDoc.getForm();

    String empDocMasterTemplateText = "";

    try {
        pinjaman = PstPinjaman.fetchExc(oidPinjaman);
    } catch (Exception exc) {
    }

    String whereDoc = PstEmpDoc.fieldNames[PstEmpDoc.FLD_PINJAMAN_ID] + " = " + oidPinjaman + " AND " + PstEmpDoc.fieldNames[PstEmpDoc.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
    Vector vListDoc = PstEmpDoc.list(0, 0, whereDoc, PstEmpDoc.fieldNames[PstEmpDoc.FLD_DATE_OF_ISSUE]);

    if (vListDoc.size() > 0) {
        empDoc = (EmpDoc) vListDoc.get(0);
        oidEmpDoc = empDoc.getOID();
        if (empDoc != null) {
            try {
                empDocMaster = PstDocMaster.fetchExc(empDoc.getDoc_master_id());
            } catch (Exception e) {
            }

            if (empDoc.getDetails().length() > 0) {
                empDocMasterTemplateText = empDoc.getDetails();
                isGeneratedBefore = true;
            } else {
                try {
                    empDocMasterTemplateText = PstDocMasterTemplate.getTemplateText(empDoc.getDoc_master_id());
                } catch (Exception e) {
                }
            }
        }
    } else {
        try {
            empDocMaster = PstDocMaster.fetchExc(oidDocMaster);
        } catch (Exception exc) {
        }

        try {
            empDocMasterTemplateText = PstDocMasterTemplate.getTemplateText(empDocMaster.getOID());
        } catch (Exception exc) {
        }

        String docNumber = docNumber(request, oidDocMaster);

        empDoc.setDate_of_issue(new Date());
        empDoc.setDoc_master_id(oidDocMaster);
        empDoc.setDoc_title(empDocMaster.getDescription() + " " + pinjaman.getNoKredit());
        empDoc.setDoc_number(docNumber);
        empDoc.setPinjamanId(oidPinjaman);
        try {
            oidEmpDoc = PstEmpDoc.insertExc(empDoc);
        } catch (Exception exc) {
        }
    }

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css" type="text/css">
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.js"></script>
        <script src="../../style/ckeditor/ckeditor.js"></script>
        <script src="../../style/ckeditor/adapters/jquery.js"></script>
        <style>
            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
              body .main-page * { visibility: hidden; display: none; } 
              body print-area * { visibility: visible; }
              body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
        </style>
    </head>
    <body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
        <div class="main-page">
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
            <tr> 
                <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
                        <tr> 
                            <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><!-- #EndEditable --></td>
                        </tr>
                        <tr> 
                            <td valign="top"><!-- #BeginEditable "content" --> 
                                <form name="frmEmpDoc" method ="post" action="">
                                    <input type="hidden" name="command" value="<%=iCommand%>">
                                    <input type="hidden" name="start" value="<%=start%>">
                                    <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                    <input type="hidden" name="oid_pinjaman" value="<%=oidPinjaman%>">
                                    <input type="hidden" name="oid_emp_doc" value="<%=oidEmpDoc%>">
                                    <input type="hidden" name="type" value="<%=type%>">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                        <%
                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("&lt", "<");
                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("<;", "<");
                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("&gt", ">");
                                            String tanpaeditor = empDocMasterTemplateText;
                                            String subString = "";
                                            String stringResidual = empDocMasterTemplateText;
                                            Vector vNewString = new Vector();

                                            String imgRoot = "";
                                            try {
                                                imgRoot = PstSystemProperty.getValueByName("COMPANY_NAME");
                                            } catch (Exception e) {
                                            }

                                            if (!imgRoot.equals("")) {
                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${COMPANY}", imgRoot);
                                            }

                                            String where1 = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                            Hashtable hlistEmpDocField = PstEmpDocField.Hlist(0, 0, where1, "");
                                            Hashtable hashCompany = new Hashtable();
                                            Hashtable hashContact = new Hashtable();
                                            Hashtable hashPinjaman = new Hashtable();
                                            Hashtable hashContactFamily = new Hashtable();
                                            Hashtable hashEmpDoc = new Hashtable();
                                            Hashtable hashLocationUser = new Hashtable();
                                            Hashtable hashEmployee = new Hashtable();

                                            long oidContact = pinjaman.getAnggotaId();

                                            String where = PstAnggotaKeluarga.fieldNames[PstAnggotaKeluarga.FLD_CONTACT_ANGGOTA_ID] + "=" + oidContact;
                                            Vector vAnggotaKeluarga = PstAnggotaKeluarga.list(0, 0, where, "");

                                            long oidAnggotaKeluarga = 0;
                                            if (vAnggotaKeluarga.size() > 0) {
                                                AnggotaKeluarga anggotaKeluarga = (AnggotaKeluarga) vAnggotaKeluarga.get(0);
                                                oidAnggotaKeluarga = anggotaKeluarga.getContactKeluargaId();
                                            }

                                            Vector listCompany = PstCompany.list(0, 0, "", "");
                                            if (listCompany != null && listCompany.size() > 0) {
                                                try {
                                                    Company company = (Company) listCompany.get(0);
                                                    hashCompany = PstCompany.fetchExcHashtable(company.getOID());
                                                } catch (Exception exc) {
                                                    System.out.println(exc.toString());
                                                }

                                                try {
                                                    hashContact = PstAnggota.fetchExcHashtable(oidContact);
                                                } catch (Exception exc) {
                                                    System.out.println(exc.toString());
                                                }

                                                try {
                                                    hashPinjaman = PstPinjaman.fetchExcHashtable(oidPinjaman);
                                                } catch (Exception exc) {
                                                    System.out.println(exc.toString());
                                                }

                                                try {
                                                    hashContactFamily = PstAnggota.fetchExcHashtable(oidAnggotaKeluarga);
                                                } catch (Exception exc) {
                                                    System.out.println(exc.toString());
                                                }

                                                try {
                                                    hashEmpDoc = PstEmpDoc.fetchExcHashtable(oidEmpDoc);
                                                } catch (Exception exc) {
                                                    System.out.println(exc.toString());
                                                }
                                                
                                                try {
                                                    Location loc = PstLocation.fetchFromApi(userLocationId);
                                                    PstLocation.convertObjectToHashTableExc(hashLocationUser, loc);
                                                } catch (Exception e) {
                                                    System.out.println(e.toString());
                                                }
                                                try {
                                                    hashEmployee = PstEmployee.getHashTableEmployee(appUserInit, pinjaman);
                                                } catch (Exception e) {
                                                    System.out.println(e.toString());
                                                }

                                            }

                                            int startPosition = 0;
                                            int endPosition = 0;
                                            int index = 0;
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
                                                    String whereC = " " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = \"" + oidEmpDoc + "\"";
                                                    Vector listEmp = PstEmpDocField.list(0, 0, whereC, "");
                                                    EmpDocField empDocField = new EmpDocField();
                                                    try {
                                                        empDocField = (EmpDocField) listEmp.get(0);
                                                        oidEmpDocField = empDocField.getOID();
                                                    } catch (Exception e) {

                                                    }

                                                    //cek dulu apakah hanya object name atau tidak
                                                    if (!objectName.equals("") && !objectType.equals("") && !objectClass.equals("") && !objectStatusField.equals("")) {
                                                        if (objectType.equals("FIELD") && objectStatusField.equals("AUTO")) {
                                                            Date newd = new Date();
                                                            String field = "04/KEP/BPD-PMT/" + newd.getMonth() + "/" + newd.getYear();
                                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", field);
                                                            tanpaeditor = tanpaeditor.replace("${" + subString + "}", field);

                                                        } else if (objectType.equals("FIELD")) {
                                                            if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("TEXT"))) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                                                            } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("MINITEXT"))) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                                                            } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.equals("LONGTEXT"))) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                                                            } else if ((objectClass.equals("ALLFIELD")) && (objectStatusField.contains("SELECT"))) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", (hlistEmpDocField.get(objectName) != null ? (String) hlistEmpDocField.get(objectName) : "-"));
                                                            } else if (objectClass.equals("SYSPROP")) {
                                                                String value = "-";
                                                                try {
                                                                    value = PstSystemProperty.getValueByName(objectStatusField);
                                                                } catch (Exception exc) {
                                                                    System.out.println(exc.toString());
                                                                }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + value);
                                                            } else if (objectClass.equals("COMPANY")) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashCompany.get(objectStatusField));
                                                            } else if (objectClass.equals("CONTACT")) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashContact.get(objectStatusField));
                                                            } else if (objectClass.equals("CONTACT_FAMILY")) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + (hashContactFamily.get(objectStatusField) != null ? hashContactFamily.get(objectStatusField) : "<span style='font-size:22px'><span style='color:#e74c3c'>â</span></span>"));
                                                            } else if (objectClass.equals("SELECTION")) {
                                                                if ((objectStatusField.equals("CONTACT"))) {

                                                                    Vector con_key = new Vector(1, 1);
                                                                    Vector con_val = new Vector(1, 1);
                                                                    Vector listContact = PstContactList.list(0, 0, "", "");
                                                                    if (listContact != null && listContact.size() > 0) {
                                                                        for (int i = 0; i < listContact.size(); i++) {
                                                                            ContactList contactList = (ContactList) listContact.get(i);
                                                                            con_key.add(contactList.getPersonName());
                                                                            con_val.add(String.valueOf(contactList.getOID()));
                                                                        }
                                                                    }
                                                                    
                                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hlistEmpDocField.get(objectName));
                                                                }
                                                            } else if (objectClass.equals("KREDIT")) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashPinjaman.get(objectStatusField));
                                                            } else if (objectClass.equals("DOCUMENT")) {
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashEmpDoc.get(objectStatusField));
                                                            } else if (objectClass.equals("USER_LOCATION")){
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + hashLocationUser.get(objectStatusField));
                                                            }
                                                        } else if (objectType.equals("EMPLOYEE_DATA")){
                                                            Hashtable temp = (Hashtable) hashEmployee.get(objectClass);
                                                            if(temp != null){
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + temp.get(objectStatusField));
                                                            }
                                                        } else if (objectType.equals("RP")) {
                                                            if (objectClass.equals("KREDIT")) {
                                                                String value = "" + hashPinjaman.get(objectStatusField);
                                                                String angka = "";
                                                                try {
                                                                    angka = Formater.formatNumber(Double.valueOf(value), "");
                                                                } catch (Exception exc) {
                                                                    System.out.println("Exception at RP");
                                                                }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Rp." + angka + ",-");
                                                            }
                                                        } else if (objectType.equals("TERBILANGRP")) {
                                                            if (objectClass.equals("KREDIT")) {
                                                                String value = "" + hashPinjaman.get(objectStatusField);
                                                                double nilai = 0;
                                                                try {
                                                                    nilai = Double.valueOf("" + hashPinjaman.get(objectStatusField));
                                                                } catch (Exception exc) {
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
                                                            if (objectClass.equals("KREDIT")) {
                                                                String value = "" + hashPinjaman.get(objectStatusField);
                                                                double nilai = 0;
                                                                try {
                                                                    nilai = Double.valueOf("" + hashPinjaman.get(objectStatusField));
                                                                } catch (Exception exc) {
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
                                                            if (objectClass.equals("KREDIT") || objectClass.equals("DATE")) {
                                                                String dateShow = "-";
                                                                if (hashPinjaman.get(objectStatusField) != null || objectStatusField.equals("NOW")) {
                                                                    SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                                                    String dateInString = "" + hashPinjaman.get(objectStatusField);

                                                                    SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                                                    try {
                                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                                        Date dateX = new Date();
                                                                        if (!objectStatusField.equals("NOW")) {
                                                                            dateX = formatterDateSql.parse(dateInString);
                                                                        }
                                                                        String strDate = sdf.format(dateX);
                                                                        String strYear = strDate.substring(0, 4);
                                                                        String strMonth = strDate.substring(5, 7);
                                                                        if (strMonth.length() > 0) {
                                                                            switch (Integer.valueOf(strMonth)) {
                                                                                case 1:
                                                                                    strMonth = "Januari";
                                                                                    break;
                                                                                case 2:
                                                                                    strMonth = "Februari";
                                                                                    break;
                                                                                case 3:
                                                                                    strMonth = "Maret";
                                                                                    break;
                                                                                case 4:
                                                                                    strMonth = "April";
                                                                                    break;
                                                                                case 5:
                                                                                    strMonth = "Mei";
                                                                                    break;
                                                                                case 6:
                                                                                    strMonth = "Juni";
                                                                                    break;
                                                                                case 7:
                                                                                    strMonth = "Juli";
                                                                                    break;
                                                                                case 8:
                                                                                    strMonth = "Agustus";
                                                                                    break;
                                                                                case 9:
                                                                                    strMonth = "September";
                                                                                    break;
                                                                                case 10:
                                                                                    strMonth = "Oktober";
                                                                                    break;
                                                                                case 11:
                                                                                    strMonth = "November";
                                                                                    break;
                                                                                case 12:
                                                                                    strMonth = "Desember";
                                                                                    break;
                                                                            }
                                                                        }
                                                                        String strDay = strDate.substring(8, 10);
                                                                        dateShow = strDay + " " + strMonth + " " + strYear;  ////formatterDate.format(dateX);

                                                                    } catch (Exception e) {
                                                                        System.out.println(e.toString());
                                                                    }
                                                                }

                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + dateShow);
                                                            }
                                                        } else if (objectType.equals("HARI")) {
                                                            String[] stDays = {
                                                                "Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"
                                                            };
                                                            if (objectClass.equals("KREDIT")) {
                                                                String day = "-";
                                                                try {
                                                                    String value = "" + hashPinjaman.get(objectStatusField);
                                                                    DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                                                                    Date result = df.parse(value);
                                                                    Calendar objCal = Calendar.getInstance();
                                                                    objCal.setTime(result);
                                                                    day = stDays[objCal.get(Calendar.DAY_OF_WEEK) - 1];
                                                                } catch (Exception exc) {
                                                                    System.out.println("Exception on PENGAJUAN_DAY");
                                                                }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + day);
                                                            }
                                                        } else if (objectType.equals("DD")) {
                                                            if (objectClass.equals("KREDIT")) {
                                                                String strDay = "-";
                                                                if (hashPinjaman.get(objectStatusField) != null) {
                                                                    SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                                                    String dateInString = "" + hashPinjaman.get(objectStatusField);

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
                                                        } else if (objectType.equals("NEXTMMMM")) {
                                                            if (objectClass.equals("KREDIT")) {
                                                                String strMonth = "-";
                                                                String strDay = "-";
                                                                if (hashPinjaman.get(objectStatusField) != null) {
                                                                    SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                                                    String dateInString = "" + hashPinjaman.get(objectStatusField);
                                                                    
                                                                    SimpleDateFormat formatterDate = new SimpleDateFormat("dd MMMM yyyy");
                                                                    try {
                                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                                        Date dateX = formatterDateSql.parse(dateInString);
                                                                        String strDate = sdf.format(dateX);
                                                                        strDay = strDate.substring(8, 10);
                                                                        strMonth = strDate.substring(5, 7);
                                                                        if (strMonth.length() > 0) {
                                                                            switch (Integer.valueOf(strMonth)+1) {
                                                                                case 1:
                                                                                    strMonth = "Januari";
                                                                                    break;
                                                                                case 2:
                                                                                    strMonth = "Februari";
                                                                                    break;
                                                                                case 3:
                                                                                    strMonth = "Maret";
                                                                                    break;
                                                                                case 4:
                                                                                    strMonth = "April";
                                                                                    break;
                                                                                case 5:
                                                                                    strMonth = "Mei";
                                                                                    break;
                                                                                case 6:
                                                                                    strMonth = "Juni";
                                                                                    break;
                                                                                case 7:
                                                                                    strMonth = "Juli";
                                                                                    break;
                                                                                case 8:
                                                                                    strMonth = "Agustus";
                                                                                    break;
                                                                                case 9:
                                                                                    strMonth = "September";
                                                                                    break;
                                                                                case 10:
                                                                                    strMonth = "Oktober";
                                                                                    break;
                                                                                case 11:
                                                                                    strMonth = "November";
                                                                                    break;
                                                                                case 12:
                                                                                    strMonth = "Desember";
                                                                                    break;
                                                                            }
                                                                        }
                                                                    } catch (Exception e) {
                                                                        e.printStackTrace();
                                                                    }
                                                                }
                                                                empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + strMonth);
                                                            }
                                                        } else if (objectType.equals("DD_TERBILANG")) {
                                                            if (objectClass.equals("KREDIT")) {
                                                                String strDay = "-";
                                                                if (hashPinjaman.get(objectStatusField) != null) {
                                                                    SimpleDateFormat formatterDateSql = new SimpleDateFormat("yyyy-MM-dd");
                                                                    String dateInString = "" + hashPinjaman.get(objectStatusField);

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
                                                                } catch (Exception exc) {
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
                                                        } else if (objectType.equals("BUNGA_AWAL")) {
                                                            String bungaKreditAwal = "0";
                                                            Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 1, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + oidPinjaman + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                                                            for (JadwalAngsuran ja : listJadwal) {
                                                                bungaKreditAwal = Formater.formatNumber(ja.getJumlahANgsuran(), "");
                                                            }
                                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Rp. " + bungaKreditAwal + ",-");
                                                        } else if (objectType.equals("DAY_OF_MONTH")) {
                                                            String jatuhTempo = "" + hashPinjaman.get(objectStatusField);
                                                            String tempo[] = jatuhTempo.split("-");
                                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "" + tempo[2]);
                                                        } else if (objectType.equals("BIAYA")) {
                                                            try {
                                                                String biaya = "0";
                                                                long idJenisTransaksi = Long.valueOf(objectStatusField);
                                                                String whereClause = PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = " + oidPinjaman
                                                                        + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI] + " = " + idJenisTransaksi;
                                                                Vector<BiayaTransaksi> listBiaya = PstBiayaTransaksi.list(0, 0, whereClause, null);
                                                                if(listBiaya.isEmpty()){
                                                                    empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Data biaya belum ada / tidak ditemukan.");
                                                                } else {
                                                                    for (BiayaTransaksi bt : listBiaya) {
                                                                        if (bt.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                                                                            biaya = Formater.formatNumber(bt.getValueBiaya(), "");
                                                                        } else {
                                                                            double value = bt.getValueBiaya() / 100 * pinjaman.getJumlahPinjaman();
                                                                            biaya = Formater.formatNumber(value, "");
                                                                        }
                                                                        empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", "Rp. " + biaya + ",-");
                                                                    }
                                                                }
                                                            } catch (Exception e) {
                                                                
                                                            }
                                                        } else if (objectType.equals("TGL_PENCAIRAN")) {
                                                            String value = "-";
                                                            String whereTransaksi = PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = " + oidPinjaman
                                                                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = " + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN;
                                                            Vector<Transaksi> listTransaksiPencairan = PstTransaksi.list(0, 0, whereTransaksi, null);
                                                            if (!listTransaksiPencairan.isEmpty()) {
                                                                Date tglTransaksi = listTransaksiPencairan.get(0).getTanggalTransaksi();
                                                                if (objectClass.equals("NUMBER")) {
                                                                    value = Formater.formatDate(tglTransaksi, objectStatusField);
                                                                } else if (objectClass.equals("TEXT")) {
                                                                    value = Formater.formatDate(tglTransaksi, objectStatusField);
                                                                } else if (objectClass.equals("ROMAN")) {
                                                                    int month = Integer.valueOf(Formater.formatDate(tglTransaksi, objectStatusField));
                                                                    String romawi[] = {"-","I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"};
                                                                    value = romawi[month];
                                                                }
                                                            }
                                                            empDocMasterTemplateText = empDocMasterTemplateText.replace("${" + subString + "}", value);
                                                        } else if (objectType.equals("LOCATION")) {
                                                            if (objectClass.equals("KOTA")){
                                                                
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

                                        <tr align="left" valign="top" >
                                            <td colspan="3"cen >
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_EMP_DOC_ID]%>"  value="<%= empDoc.getOID()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_MASTER_ID]%>"  value="<%= empDoc.getDoc_master_id()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_TITLE]%>"  value="<%= empDoc.getDoc_title()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_REQUEST_DATE]%>"  value="<%= empDoc.getRequest_date()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DOC_NUMBER]%>"  value="<%= empDoc.getDoc_number()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DATE_OF_ISSUE]%>"  value="<%= empDoc.getDate_of_issue()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_PLAN_DATE_FROM]%>"  value="<%= empDoc.getPlan_date_from()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_PLAN_DATE_TO]%>"  value="<%= empDoc.getPlan_date_to()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_REAL_DATE_FROM]%>"  value="<%= empDoc.getReal_date_from()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_REAL_DATE_TO]%>"  value="<%= empDoc.getReal_date_to()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_OBJECTIVES]%>"  value="<%= empDoc.getObjectives()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_COUNTRY_ID]%>"  value="<%= empDoc.getCountry_id()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_PROVINCE_ID]%>"  value="<%= empDoc.getProvince_id()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_REGION_ID]%>"  value="<%= empDoc.getRegion_id()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_SUBREGION_ID]%>"  value="<%= empDoc.getSubregion_id()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_GEO_ADDRESS]%>"  value="<%= empDoc.getGeo_address()%>" class="elemenForm" size="30">
                                                <input type="hidden" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_PINJAMAN_ID]%>"  value="<%= empDoc.getPinjamanId()%>" class="elemenForm" size="30">

                                                <textarea class="ckeditor" name="<%=frmEmpDoc.fieldNames[FrmEmpDoc.FRM_FIELD_DETAILS]%>"  cols="100" rows="150"><%=empDocMasterTemplateText%></textarea>

                                            </td>
                                        </tr>

                                    </table>
                                </form>

                                <!-- #EndEditable --></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr> 
                <td colspan="2" height="20" class="footer"> 
                    <%//@ include file = "../../main/footer.jsp" %>
                </td>
            </tr>
        </table>
        </div>
    <print-area>
        <%=empDocMasterTemplateText%>
    </print-area>        
            <script type="text/javascript">
                $(function() {
                    // Replace the <textarea id="editor1"> with a CKEditor
                    // instance, using default configuration.
                    CKEDITOR.replace("#editor1",
                    {
                         height: 800
                    });

                    //bootstrap WYSIHTML5 - text editor
                    //$(".textarea").ckeditor();
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
                  var overridesave = new CKEDITOR.command(editor, {
                      exec: function(editor){
                          // Replace this with your desired save button code
                          document.frmEmpDoc.command.value="<%=Command.POST%>";
                          document.frmEmpDoc.prev_command.value="<%=prevCommand%>";
                          document.frmEmpDoc.action="dokumen_edit.jsp";
                          document.frmEmpDoc.submit();
                      }
                  });
                  
                  var overrideprint = new CKEDITOR.command(editor, {
                      exec: function(editor){
                          //var linkPage = "<%=approot%>/AjaxDocument?oid_emp_doc=<%=oidEmpDoc%>&hidden_docmaster_id=<%=oidDocMaster%>&oid_pinjaman=<%=oidPinjaman%>"; 
                          //var newWin = window.open(linkPage,"Leave","height=650,width=1000,left=300,status=yes,toolbar=yes,menubar=no,resizable=yes,scrollbars=yes,location=yes");  			
                          //newWin.focus();
                          window.print();
                      }
                  });
                  
                  // Replace the old save's exec function with the new one
                  ev.editor.commands.newpage.exec = overridecmd.exec;
                  ev.editor.commands.save.exec = overridesave.exec;
                  ev.editor.commands.print.exec = overrideprint.exec;
              });

              CKEDITOR.replace('CKEditor1');

          </script>
    </body>
</html>
