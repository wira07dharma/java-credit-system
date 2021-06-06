<%-- 
    Document   : doc_template
    Created on : 19-Dec-2017, 14:11:41
    Author     : Gunadi
--%>
<%@page import="com.dimata.sedana.entity.masterdata.PstEmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.entity.masterdata.EmpRelevantDocGroup"%>
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

<%@include file="../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
    int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_DOCUMENT, AppObjInfo.OBJ_DOCUMENT_TEMPLATE);%>
<%@ include file = "../../main/checkuser.jsp" %>

<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!DOCTYPE html>
<%!
    public static final String textListTitle[][]
            = {
                {"Nama Template", "Master Dokumen", "Batas Atas", "Batas Kanan", "Batas Kiri", "Batas Bawah", "Tampilkan / Sembunyikan"},
                {"Template Name", "Document Master", "Top Margin", "Right Margin", "Left Margin", "Bottom Margin", "Show / Hide"}
            };

%>

<%
    int iCommand = FRMQueryString.requestCommand(request);
    int start = 0;
//    int start = FRMQueryString.requestInt(request, "start");
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
    Vector listDocMasterTemplate = new Vector(1, 1);


    /* end switch */
    FrmDocMasterTemplate frmDocMasterTemplate = ctrlDocMasterTemplate.getForm();

    long sdocmasterId = FRMQueryString.requestLong(request, FrmDocMasterTemplate.fieldNames[FrmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID]);

    if (oidDocMaster > 0) {
        whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + oidDocMaster;
    } else {
        whereClause = PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + sdocmasterId;
    }
    listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);

    DocMasterTemplate docMasterTemplateObj = new DocMasterTemplate();
    if (listDocMasterTemplate.size() > 0) {

        try {
            docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
        } catch (Exception e) {
        }
    }
    oidDocMasterTemplate = docMasterTemplateObj.getOID();
    iErrCode = ctrlDocMasterTemplate.action(iCommand, oidDocMasterTemplate);

    listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);

    if (listDocMasterTemplate.size() > 0) {
        try {
            docMasterTemplateObj = (DocMasterTemplate) listDocMasterTemplate.get(0);
        } catch (Exception e) {
        }
    }

    /*count list All DocMasterTemplate*/
    int vectSize = PstDocMasterTemplate.getCount(whereClause);

    /*switch list DocMasterTemplate*/
    if ((iCommand == Command.FIRST || iCommand == Command.PREV) || (iCommand == Command.NEXT || iCommand == Command.LAST)) {
        start = ctrlDocMasterTemplate.actionList(iCommand, start, vectSize, recordToGet);
    }
    /* end switch list*/

    DocMasterTemplate docMasterTemplate = ctrlDocMasterTemplate.getdDocMasterTemplate();
    msgString = ctrlDocMasterTemplate.getMessage();

    /* get record to display */

    /*handle condition if size of record to display = 0 and start > 0 	after delete*/
    if (listDocMasterTemplate.size() < 1 && start > 0) {
        if (vectSize - recordToGet > recordToGet) {
            start = start - recordToGet;   //go to Command.PREV
        } else {
            start = 0;
            iCommand = Command.FIRST;
            prevCommand = Command.FIRST; //go to Command.FIRST
        }
        listDocMasterTemplate = PstDocMasterTemplate.list(start, recordToGet, whereClause, orderClause);
    }
    if (oidDocMaster > 0) {
        docMasterTemplate.setDoc_master_id(oidDocMaster);
    } else {
        docMasterTemplate.setDoc_master_id(sdocmasterId);
    }
    
    float marginTop = docMasterTemplate.getTopMargin();
    float marginBottom = docMasterTemplate.getBottomMargin();
    float marginLeft = docMasterTemplate.getLeftMargin();
    float marginRight = docMasterTemplate.getRightMargin();

    String listDocGroup = "";
    Vector<EmpRelevantDocGroup> listDocGroups = PstEmpRelevantDocGroup.listAll();
    for(EmpRelevantDocGroup doc : listDocGroups){
        listDocGroup += "<li>Foto " + doc.getDocGroup() + " : ${CONTACT-FIELD-KREDIT-FOTO_" + doc.getDocGroup().toUpperCase() + "} </li>";
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <script src="../../style/ckeditor/ckeditor.js"></script>
        <script src="../../style/ckeditor/adapters/jquery.js"></script>
        <title>Accounting Information System Online</title>
        <script type="text/javascript">
            function cmdSave() {
                document.frmDocMasterTemplate.command.value = "<%=Command.SAVE%>";
                document.frmDocMasterTemplate.action = "doc_template.jsp";
                document.frmDocMasterTemplate.submit();
            }
            
            function cmdBack() {
                document.frmDocMasterTemplate.command.value = "<%=Command.LIST%>";
                document.frmDocMasterTemplate.action = "doc_master.jsp";
                document.frmDocMasterTemplate.submit();
            }

            function cmdPreview(oidDocMaster, oidDocMasterTemplate) {
                document.frmDocMasterTemplate.command.value = "<%=Command.LIST%>";
                document.frmDocMasterTemplate.action = "doc_example.jsp";
                document.frmDocMasterTemplate.submit();
                //window.open("doc_example.jsp?command=<%=Command.LIST%>&doc_master_template_oid="+oidDocMasterTemplate+"&hidden_docmaster_id="+oidDocMaster);
            }

            function cmdAddHeader(oidDocMaster, oidDocMasterTemplate) {
                window.open("doc_header.jsp?doc_master_template_oid=" + oidDocMasterTemplate + "&hidden_docmaster_id=" + oidDocMaster, null, "height=550,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }

            function headerToogle() {
                if (document.getElementById('header').style.display === 'none') {
                    document.getElementById('header').style.display = '';
                    document.getElementById('headerTop').style.display = '';
                } else {
                    document.getElementById('header').style.display = 'none';
                    document.getElementById('headerTop').style.display = 'none';
                }
            }

            function footerToogle() {
                if (document.getElementById('footer').style.display === 'none') {
                    document.getElementById('footer').style.display = '';
                    document.getElementById('footerTop').style.display = '';
                } else {
                    document.getElementById('footer').style.display = 'none';
                    document.getElementById('footerTop').style.display = 'none';
                }
            }
            
            function formulaToogle() {
                if (document.getElementById('formula').style.display === 'none') {
                    document.getElementById('formula').style.display = '';
                } else {
                    document.getElementById('formula').style.display = 'none';
                }
            }
        </script>
        <link rel="stylesheet" href="../../style/main.css" type="text/css">
        <link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
        <script type="text/javascript" src="../../dtree/dtree.js"></script>
        <style>
            #formula li {padding-bottom: 5px}
        </style>
    </head>
    <body style="background-color: #E6E9ED">
        <h3>Master Bumdesa > Master Dokumen > Template Dokumen</h3>
        
        <form name="frmDocMasterTemplate" method ="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
            <input type="hidden" name="vectSize" value="<%=vectSize%>">
            <input type="hidden" name="start" value="<%=start%>">
            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
            <input type="hidden" name="doc_master_template_oid" value="<%=oidDocMasterTemplate%>">
            <input type="hidden" name="hidden_docmaster_id" value="<%=oidDocMaster%>">
            
            <table width="100%" border="0" cellpadding="0" cellspacing="5" class="listgenactivity">
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][0]%></strong></td>
                    <td width="80%">
                        <input type="text" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEMPLATE_TITLE]%>"  value="<%= docMasterTemplateObj.getTemplate_title()%>" size="50">
                        *) <%=frmDocMasterTemplate.getErrorMsg(frmDocMasterTemplate.FRM_FIELD_TEMPLATE_TITLE)%>
                    </td>
                    <td width="10%">&nbsp;</td>
                </tr>
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][1]%></strong></td>
                    <td width="80%">
                        <%
                            Vector docmaster_value = new Vector(1, 1);
                            Vector docmaster_key = new Vector(1, 1);
                            Vector listdocmaster = PstDocMaster.list(0, 0, "", "");
                            docmaster_value.add("" + 0);
                            docmaster_key.add("select");
                            for (int i = 0; i < listdocmaster.size(); i++) {
                                DocMaster docMaster = (DocMaster) listdocmaster.get(i);
                                docmaster_key.add(docMaster.getDoc_title());
                                docmaster_value.add(String.valueOf(docMaster.getOID()));
                            }
                        %>
                        <%= ControlCombo.draw(FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_DOC_MASTER_ID], "", null, "" + (docMasterTemplate.getDoc_master_id() != 0 ? docMasterTemplate.getDoc_master_id() : oidDocMaster), docmaster_value, docmaster_key, "")%>
                    </td>
                    <td width="10%">&nbsp;</td>
                </tr>
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][2]%></strong></td>
                    <td width="80%"><input type="text" name="<%=FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TOP_MARGIN]%>" value="<%=docMasterTemplate.getTopMargin()%>"></td>
                    <td width="10%">&nbsp;</td>                                
                </tr>
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][3]%></strong></td>
                    <td width="80%"><input type="text" name="<%=FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_RIGHT_MARGIN]%>" value="<%=docMasterTemplate.getRightMargin()%>"></td>
                    <td width="10%">&nbsp;</td>                                
                </tr>
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][4]%></strong></td>
                    <td width="80%"><input type="text" name="<%=FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_LEFT_MARGIN]%>" value="<%=docMasterTemplate.getLeftMargin()%>"></td>
                    <td width="10%">&nbsp;</td>                                
                </tr>
                <tr>
                    <td width="10%"><strong><%=textListTitle[SESS_LANGUAGE][5]%></strong></td>
                    <td width="80%"><input type="text" name="<%=FrmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_BOTTOM_MARGIN]%>" value="<%=docMasterTemplate.getBottomMargin()%>"></td>
                    <td width="10%">&nbsp;</td>                                
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="2"><a href="javascript:formulaToogle()" style="text-decoration-line: none"><strong>Formula</strong></a></td>
                </tr>
                <tr id="formula" style="display: none">
                    <td>&nbsp;</td>
                    <td colspan="2">
                        <table>
                            <tr>
                                <td style="vertical-align: top;">
                                    <span>Data Dokumen :</span>
                                    <ol>
                                        <li>Nomor dokumen : <%= "${NO-FIELD-DOCUMENT-DOC_NUMBER}" %></li>
                                        <li>Nomor SPP : <%= "${NO-FIELD-DOCUMENT-SPP_DOC_NUMBER}" %></li>
                                        <li>Tanggal hari ini : <%= "${TGL-TANGGAL-DATE-NOW}" %></li>
                                    </ol>
                                    <!--
                                    <span>Data Bumdes :</span>
                                    <ol>
                                        <li>Nama bumdes : <%= "${BUMDES-FIELD-SYSPROP-COMPANY_NAME}" %></li>
                                        <li>Alamat bumdes : <%= "${BUMDES-FIELD-SYSPROP-COMPANY_ADDRESS}" %></li>
                                    </ol>
                                    -->
                                    <span>Data <%=namaNasabah %> :</span>
                                    <ol>
                                        <li>Nama <%=namaNasabah %> : <%= "${CONTACT-FIELD-CONTACT-PERSON_NAME}" %></li>
                                        <li>Jenis kelamin : <%= "${STRING-FIELD-CONTACT-MEMBER_SEX}" %></li>
                                        <li>Alamat <%=namaNasabah %> : <%= "${CONTACT-FIELD-CONTACT-HOME_ADDRESS}" %></li>
                                        <li>Tanggal lahir : <%= "${CONTACT-FIELD-CONTACT-MEMBER_BIRTH_DATE}" %></li>
                                        <li>Tempat lahir : <%= "${CONTACT-FIELD-CONTACT-MEMBER_BIRTH_PLACE}" %></li>
                                        <li>Nomor KTP : <%= "${CONTACT-FIELD-CONTACT-KTP_NO}" %></li>
                                        <li>Pekerjaan : <%= "${CONTACT-FIELD-CONTACT-MEMBER_VOCATION_ID}" %></li>
                                        <li>Alamat Pekerjaan : <%= "${CONTACT-FIELD-CONTACT-COMP_ADDRESS}" %></li>
                                        <li>Nomor telepon : <%= "${NUMBER-FIELD-CONTACT-TELP_NR}" %></li>
                                        <li>Nomor HP : <%= "${NUMBER-FIELD-CONTACT-TELP_MOBILE}" %></li>
                                        <li>Nama Penanggung <%=namaNasabah %> : <%= "${CONTACT-FIELD-CONTACT-PENANGGUNG_NAME}" %></li>
                                        <li>Hubungan Penanggung : <%= "${CONTACT-FIELD-CONTACT-PENANGGUNG_RELATION}" %></li>
                                        <li>Alamat Penanggung : <%= "${CONTACT-FIELD-CONTACT-PENANGGUNG_ADDRESS}" %></li>
                                        <li>Handphone Penanggung : <%= "${CONTACT-FIELD-CONTACT-PENANGGUNG_HANDPHONE}" %></li>
                                        <li>Telepon Penanggung : <%= "${CONTACT-FIELD-CONTACT-PENANGGUNG_TELEPHONE}" %></li>
                                    </ol>
                                    <span>Dokumen <%=namaNasabah %> :</span>
                                    <ol><%= listDocGroup %></ol>
                                    <span>Data User :</span>
                                    <ol>
                                        <li>Lokasi : <%= "${USER-FIELD-USER_LOCATION-NAME}" %></li>
                                        <li>Alamat Lokasi : <%= "${USER-FIELD-USER_LOCATION-ADDRESS}" %></li>
                                        <li>Email Lokasi : <%= "${USER-FIELD-USER_LOCATION-EMAIL}" %></li>
                                        <li>Telp. Lokasi : <%= "${USER-FIELD-USER_LOCATION-TELEPHONE}" %></li>
                                        <li>Fax. Lokasi : <%= "${USER-FIELD-USER_LOCATION-FAX}" %></li>
                                    </ol>
                                </td>
                                <td style="vertical-align: top;">
                                    <span>Data Karyawan :</span>
                                    <ol>
                                        <li>Manager Operasional (M.O.) : <%= "${EMPLOYEE-EMPLOYEE_DATA-MANAGER_OPR-FULL_NAME}" %></li>
                                        <li>Nama Analis : <%= "${EMPLOYEE-EMPLOYEE_DATA-ANALIS_KREDIT-FULL_NAME}" %></li>
                                        <li>Kode Analis : <%= "${EMPLOYEE-EMPLOYEE_DATA-ANALIS_KREDIT-EMPLOYEE_NUM}" %></li>
                                        <li>Nama Kolektor : <%= "${EMPLOYEE-EMPLOYEE_DATA-KOLEKTOR_KREDIT-FULL_NAME}" %></li>
                                        <li>Kode Kolektor : <%= "${EMPLOYEE-EMPLOYEE_DATA-KOLEKTOR_KREDIT-EMPLOYEE_NUM}" %></li>
                                    </ol>
                                    <span>Data Kredit :</span>
                                    <ol>
                                        <li>Nomor kredit : <%= "${STRING-FIELD-KREDIT-NO_KREDIT}" %></li>
                                        <li>Nama kredit : <%= "${STRING-FIELD-KREDIT-TGL_PENGAJUAN}" %></li>
                                        <li>Frekuensi angsuran : <%= "${STRING-FIELD-KREDIT-FREKUENSI_ANGSURAN}" %></li>
                                        <li>Tipe bunga : <%= "${STRING-FIELD-KREDIT-TIPE_BUNGA}" %></li>
                                        <li>Tanggal pengajuan kredit : <%= "${DATE-TANGGAL-KREDIT-TGL_PENGAJUAN}" %></li>
                                        <li>Hari pengajuan kredit : <%= "${DAY-HARI-KREDIT-TGL_PENGAJUAN}" %></li>
                                        <li>Tanggal jatuh tempo : <%= "${DATE-TANGGAL-KREDIT-JATUH_TEMPO}" %></li>
                                        <li>Angsuran awal + biaya admin : <%= "${PK-RP-KREDIT-JUMLAH_ANGSURAN_PERTAMA}" %></li>
                                        <li>Angsuran awal + biaya admin (Terbilang): <%= "${NOMINAL-TERBILANG-KREDIT-JUMLAH_ANGSURAN_PERTAMA}" %></li>
                                        <li>Jumlah pengajuan kredit (Rp) : <%= "${PK-RP-KREDIT-JUMLAH_PINJAMAN}" %></li>
                                        <li>Jumlah pengajuan kredit (Terbilang) : <%= "${PK-TERBILANGRP-KREDIT-JUMLAH_PINJAMAN}" %></li>
                                        <li>Suku bunga : <%= "${PK-FIELD-KREDIT-SUKU_BUNGA}" %></li>
                                        <li>Angsuran bunga awal : <%= "${RP-BUNGA_AWAL-KREDIT-BUNGA}" %></li>
                                        <li>Jangka waktu : <%= "${PK-FIELD-KREDIT-JANGKA_WAKTU}" %></li>
                                        <li>Jumlah angsuran : <%= "${PK-RP-KREDIT-JUMLAH_ANGSURAN}" %></li>
                                        <li>Jumlah angsuran (Terbilang): <%= "${NOMINAL-TERBILANG-KREDIT-JUMLAH_ANGSURAN}" %></li>
                                        <li>Biaya administrasi : <%= "${DOUBLE-BIAYA-KREDIT-504404661315797595}" %></li>
                                        <li>Biaya transport : <%= "${DOUBLE-BIAYA-KREDIT-504404732135801782}" %></li>
                                        <li>Sisa angsuran (Rp) : <%= "${NOMINAL-RP-KREDIT-SISA}" %></li>
                                        <li>Sisa angsuran (Terbilang) : <%= "${NOMINAL-TERBILANG-KREDIT-SISA}" %></li>
                                        <li>Tujuan kredit : <%= "${STRING-FIELD-KREDIT-KETERANGAN}" %></li>
                                        <li>Bulan kredit : <%= "${KREDIT-TGL_PENCAIRAN-TEXT-MMMM}" %></li>
                                        <li>Bulan kredit romawi : <%= "${KREDIT-TGL_PENCAIRAN-ROMAN-MM}" %></li>
                                        <li>Tahun kredit : <%= "${KREDIT-TGL_PENCAIRAN-NUMBER-yyyy}" %></li>
                                        <li>List Nama Barang : <%= "${ARRAY-FIELD-KREDIT-DATA_BARANG}" %></li>
                                        <li>List Nama Barang Mendatar : <%= "${ARRAY-FIELD-KREDIT-DATA_BARANG_HORIZONTAL}" %></li>
                                        <li>List Merk Barang : <%= "${ARRAY-FIELD-KREDIT-DATA_MERK}" %></li>
                                        <li>List Tipe Barang : <%= "${ARRAY-FIELD-KREDIT-DATA_TYPE}" %></li>
                                        <li>List Qty. Barang : <%= "${ARRAY-FIELD-KREDIT-DATA_QTY}" %></li>
                                        <li>Jumlah Uang Muka (DP) : <%= "${PK-RP-KREDIT-DOWN_PAYMENT}" %></li>
                                        <li>Jumlah Biaya Kredit : <%= "${PK-RP-KREDIT-JUMLAH_BIAYA}" %></li>
                                        <li>Jumlah Tunggakan Pinjaman Pokok : <%= "${PK-RP-KREDIT-JUMLAH_TUNGGAKAN_POKOK}" %></li>
                                        <li>Jumlah Tunggakan Pinjaman Bunga : <%= "${PK-RP-KREDIT-JUMLAH_TUNGGAKAN_BUNGA}" %></li>
                                        <li>Jumlah Tunggakan Pinjaman Denda : <%= "${PK-RP-KREDIT-JUMLAH_TUNGGAKAN_DENDA}" %></li>
                                        <li>Jumlah Denda Kredit : <%= "${PK-RP-KREDIT-JUMLAH_DENDA}" %></li>
                                        <li>Total Tunggakan Kredit : <%= "${PK-RP-KREDIT-TOTAL_TUNGGAKAN_PINJAMAN}" %></li>
                                    </ol>
                                </td>
                            </tr>
                        </table>
                        
                    </td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td width="10%">&nbsp;</td>
                    <td colspan="2">
                        <a class="btn-primary btn-sm" style="color:#FFF" onclick="javascript:headerToogle()"><i class="fa fa-plus"></i> <%=textListTitle[SESS_LANGUAGE][6]%> Header</a>
                    </td>
                </tr>
                <tr id="headerTop" style="display: none">
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr id="header" style="display: none">
                    <td width="10%">&nbsp;</td>
                    <td width="80%">
                        <div>
                            <textarea id="editor2" class="ckeditor" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_HEADER]%>" class="elemenForm" cols="70" rows="40"><%= docMasterTemplateObj.getText_header()%></textarea>
                        </div>
                    </td>
                    <td width="10%">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td width="10%">&nbsp;</td>
                    <td width="80%">
                        <%
                            String value = docMasterTemplateObj.getText_template();
                            if (false && value.equals("")) {
                                value = ""
                                        + "<div class='document-editor'>"
                                        //+ "<div style='size: legal; margin-top: "+ marginTop +"; margin-bottom: " + marginBottom + "; margin-left: " + marginLeft + "; margin-right: " + marginRight + "'>"
                                        //+ "</div>"
                                        + " <table style='height:100%; width:100%'>"
                                        + "     <tbody>"
                                        + "         <tr>"
                                        + "             <td style='vertical-align:top'>&nbsp;</td>"
                                        + "         </tr>"
                                        + "     </tbody>"
                                        + " </table>"
                                        + "<div>&nbsp;</div>"
                                        + "</div>";
                            }
                        %>
                        <textarea id="editor1" class="ckeditor" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_TEMPLATE]%>" class="elemenForm" cols="70" rows="40"><%=value%></textarea>
                    </td>
                    <td width="10%">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td width="10%">&nbsp;</td>
                    <td colspan="2">
                        <a class="btn-primary btn-sm" style="color:#FFF" onclick="javascript:footerToogle()"><i class="fa fa-plus"></i> <%=textListTitle[SESS_LANGUAGE][6]%> Footer</a>
                    </td>
                </tr>
                <tr id="footerTop" style="display: none">
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr id="footer" style="display: none">
                    <td width="10%">&nbsp;</td>
                    <td width="80%">
                        <div>
                            <textarea id="editor3" class="ckeditor" name="<%=frmDocMasterTemplate.fieldNames[frmDocMasterTemplate.FRM_FIELD_TEXT_FOOTER]%>" class="elemenForm" cols="70" rows="40"><%= docMasterTemplateObj.getText_footer()%></textarea>
                        </div>
                    </td>
                    <td width="10%">&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr align="left" valign="top"> 
                    <td height="8" align="left" colspan="3" class="command"> 
                        <a class="btn-primary btn-sm" style="color:#FFF" href="javascript:cmdSave()"><i class="fa fa-save"></i> Simpan</a> 
                        <a class="btn-delete btn-sm" style="color:#FFF" href="javascript:cmdBack()"><i class="fa fa-ban"></i> Batal</a> 
                        <a class="btn-edit btn-sm" style="color:#FFF" href="javascript:cmdPreview('<%= oidDocMaster %>','<%= oidDocMasterTemplate %>')"><i class="fa fa-search"></i> Preview</a> 
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>

        </form>
        <script type="text/javascript">
            $(function () {
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace("#editor1",
                        {
                            height: 800
                        });

                //bootstrap WYSIHTML5 - text editor
                //$(".textarea").ckeditor();
            });
            $(document).on('click', '.cke_button__pagebreak', function () {
                var editor_data = CKEDITOR.instances["editor1"].getData();
                CKEDITOR.instances["editor1"].setData(editor_data + "<div class='document-editor'><table style='height:100%; width:100%'><tbody><tr><td style='vertical-align:top'>&nbsp;</td></tr></tbody></table><div>&nbsp;</div></div>");
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
                    exec: function (editor) {
                        // Replace this with your desired save button code
                        var editor_data = CKEDITOR.instances["editor1"].getData();
                        CKEDITOR.instances["editor1"].setData(editor_data + "<div class='document-editor'><table style='height:100%; width:100%'><tbody><tr><td style='vertical-align:top'>&nbsp;</td></tr></tbody></table><div>&nbsp;</div></div>");
                    }
                });

                // Replace the old save's exec function with the new one
                ev.editor.commands.newpage.exec = overridecmd.exec;
            });

            CKEDITOR.replace('CKEditor1');

        </script>
    </body>
</html>
