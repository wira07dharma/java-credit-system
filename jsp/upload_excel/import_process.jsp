<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<%@ page import="com.dimata.util.blob.TextLoader,
			 java.io.FileOutputStream,
			 java.io.ByteArrayInputStream,
			 java.io.InputStream,
			 org.apache.poi.hssf.usermodel.HSSFDateUtil,
			 com.dimata.util.Excel,
			 com.dimata.qdep.form.FRMQueryString"%>
<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>

<!-- import harisma-->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_CLOSE_BOOK, AppObjInfo.OBJ_PERIOD_CLOSE_BOOK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<!-- JSP Block -->
<%!
/* this constant used to list text of listHeader */
public static final String pageTitle[] = {
	"Import Data","Import Data"	
};

private static final String strList[][] = {
	{"Perkiraan","Aktiva Tetap","Kontak","Hutang","Piutang"},
	{"Chart of Account","Fixed Asset","Contact","Account Payable","Account Receivable"}
};

private static String drawCell(Vector vDataExcel, boolean stserror, String fieldName, int index){
	String strList = "";
	String strData = "";
	if(vDataExcel.elementAt(index) != null)
		strData = vDataExcel.elementAt(index).toString();
		else
		strData = "-";
	
	System.out.println("strData index ke : "+index+" = "+strData);	
	try{
		if(vDataExcel.elementAt(index)!=null){
			strList = "<td class=\"listgensell\"><input type=\"hidden\" name=\""+fieldName+"\" value=\"" + strData + "\">"+strData+"</td>";
		}else{
			stserror = true;
			strList =  "<td class=\"listgensell\"><input type=\"hidden\" name=\""+fieldName+"\" value=\"\">&nbsp;</td>";
		}
	}catch(Exception e){
		strList = "";
		System.out.println("Exception on drawCell() ::: "+e.toString());
		e.printStackTrace();
	}
	return strList;
}
%>

<%
// ngambil data dari request form
int iCommand = FRMQueryString.requestCommand(request);

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">	
	
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=pageTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
           <%
					// ngambil/upload file sesuai dengan yang dipilih oleh "browse"
					TextLoader uploader = new TextLoader();
					FileOutputStream fOut = null;
					Vector vDataExcel = new Vector();
				    Vector vectErr = new Vector();
					try{
						uploader.uploadText(config, request, response);
                        int iIndexFile = Integer.parseInt(uploader.getRequestText("file_type"));
						
						Object obj = uploader.getTextFile("file");
						
						session.putValue("INDEX_FILE", String.valueOf(iIndexFile));
						
						byte byteText[] = null;
						byteText = (byte[]) obj;
						ByteArrayInputStream objByteArrayInputStream = new ByteArrayInputStream(byteText);
						Excel objExcel = new Excel();
						
						int iAmountColoumn = 9;
						switch(iIndexFile){
							case 0 :
								iAmountColoumn = 9; 
							break;
							case 1 :
								iAmountColoumn = 17; 
							break;
						}
						vDataExcel = objExcel.ReadStream((InputStream) objByteArrayInputStream, iIndexFile, iAmountColoumn);
						double dt = 0.0;
						
						// proses data chart account
						out.println("<form name=\"frmimportdata\" method=\"post\" action=\"import_save.jsp?"+iIndexFile+"\">");
						switch(iIndexFile){
							case 0 :
                            	out.println("&nbsp;<b>List "+strList[SESS_LANGUAGE][0]+"</b>");
							break;
							case 1 :
                            	out.println("&nbsp;<b>List "+strList[SESS_LANGUAGE][1]+"</b>");
							break;
                        }
						out.println("<table><tr><td>");
					    out.println("<table class=\"listgen\" cellpadding=\"1\" cellspacing=\"1\">");
					
					if(vDataExcel !=null && vDataExcel.size() > 0){
						// create header/title
						out.println("<tr>");
						for(int t = 0; t < iAmountColoumn; t++){
							out.println("<td class=\"listgentitle\">"+vDataExcel.elementAt(t)+"</td>");
							System.out.println("vDataExcel.size() "+vDataExcel.size());
						}
						out.println("</tr>");
                            // Create Title
							switch(iIndexFile){
								case 0 :
									for(int i = iAmountColoumn; i<vDataExcel.size(); i++){
										boolean stserror = false;
										String[] arrErrMessage = new String[iAmountColoumn];
										 // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
										//int it = i / numcol;
										switch ((i % iAmountColoumn)){
											case 0 : // kalo sisanya 0 ==> pada kolom I (department)
												out.println("<tr>");
												out.println(drawCell(vDataExcel, stserror, "department",i));
												break;
	
											case 1 : // kalo sisanya 1 ==> pada kolom II (parent_account)
												out.println(drawCell(vDataExcel, stserror, "parent_account",i));
												break;
	
											case 2 : // kalo sisanya 2 ==> pada kolom III (account_code)
												out.println(drawCell(vDataExcel, stserror, "account_code",i));
												break;
	
											case 3 : // kalo sisanya 3 ==> pada kolom IV (acc_name_indo)
												out.println(drawCell(vDataExcel, stserror, "acc_name_indo",i));
												break;
	
											case 4 : // kalo sisanya 4 ==> pada kolom V (acc_name_english)
												out.println(drawCell(vDataExcel, stserror, "acc_name_english",i));
												break;
	
											case 5 : // kalo sisanya 6 ==> pada kolom VII (level)
												out.println(drawCell(vDataExcel, stserror, "level",i));
												break;
	
											case 6 : // kalo sisanya 7 ==> pada kolom VIII (normal_assign)
												out.println(drawCell(vDataExcel, stserror, "normal_assign",i));
												break;
	
											case 7 : // kalo sisanya 8 ==> pada kolom IX (status)
												out.println(drawCell(vDataExcel, stserror, "status",i));
												break;
												
											case 8 : // kalo sisanya 9 ==> pada kolom IX (acc_group)
												out.println(drawCell(vDataExcel, stserror, "acc_group",i));
											break;
	
											
											default :
												out.println("<td class=\"listgensell\">" + vDataExcel.elementAt(i) + "</td>");
												break;
	
										}// End switch column
										if(stserror)
											vectErr.add(arrErrMessage);
									} // End for(int i = iAmountColoumn; i<vDataExcel.size(); i++)
								break;
								
								case 1 :
									for(int i = iAmountColoumn; i<vDataExcel.size(); i++){
										boolean stserror = false;
										String[] arrErrMessage = new String[iAmountColoumn];
										 // dicheck sisa hasil bagi antara i dengan numcol, maka akan diproses sbb :
										//int it = i / numcol;
										switch ((i % iAmountColoumn)){
											case 0 : // kalo sisanya 0 ==> pada kolom I (code)
												out.println("<tr>");
												out.println(drawCell(vDataExcel, stserror, "code",i));
												break;
	
											case 1 : // kalo sisanya 1 ==> pada kolom II (name)
												out.println(drawCell(vDataExcel, stserror, "name",i));
												break;
	
											case 2 : // kalo sisanya 2 ==> pada kolom III (assets_type)
												out.println(drawCell(vDataExcel, stserror, "assets_type",i));
												break;
	
											case 3 : // kalo sisanya 3 ==> pada kolom IV (dep_type)
												out.println(drawCell(vDataExcel, stserror, "dep_type",i));
												break;
	
											case 4 : // kalo sisanya 4 ==> pada kolom V (dep_method)
												out.println(drawCell(vDataExcel, stserror, "dep_method",i));
												break;
	
											case 5 : // kalo sisanya 6 ==> pada kolom VI (dep_period)
												out.println(drawCell(vDataExcel, stserror, "dep_period",i));
												break;
	
											case 6 : // kalo sisanya 7 ==> pada kolom VII (persen_dep)
												out.println(drawCell(vDataExcel, stserror, "persen_dep",i));
												break;
	
											case 7 : // kalo sisanya 8 ==> pada kolom VIII (basic_amount)
												out.println(drawCell(vDataExcel, stserror, "basic_amount",i));
												break;
												
											case 8 : // kalo sisanya 9 ==> pada kolom IX (residue_amount)
												out.println(drawCell(vDataExcel, stserror, "residue_amount",i));
											break;
											
											case 9 : // kalo sisanya 9 ==> pada kolom X (assets_account)
												out.println(drawCell(vDataExcel, stserror, "assets_account",i));
											break;
											
											case 10 : // kalo sisanya 10 ==> pada kolom XI (dep_assets_account)
												out.println(drawCell(vDataExcel, stserror, "dep_assets_account",i));
											break;
											
											case 11 : // kalo sisanya 11 ==> pada kolom XII (acm_dep_acc)
												out.println(drawCell(vDataExcel, stserror, "acm_dep_acc",i));
											break;
											
											case 12 : // kalo sisanya 12 ==> pada kolom XIII (other_revenue)
												out.println(drawCell(vDataExcel, stserror, "other_revenue",i));
											break;
											
											case 13 : // kalo sisanya 13 ==> pada kolom XIV (receive_date)
												out.println(drawCell(vDataExcel, stserror, "receive_date",i));
											break;
											
											case 14 : // kalo sisanya 14 ==> pada kolom XV (total_dep)
												out.println(drawCell(vDataExcel, stserror, "total_dep",i));
											break;
											
											case 15 : // kalo sisanya 15 ==> pada kolom XVI (other_exp_acc)
												out.println(drawCell(vDataExcel, stserror, "other_exp_acc",i));
											break;
											
											case 16 : // kalo sisanya 16 ==> pada kolom XVII (assets_group)
												out.println(drawCell(vDataExcel, stserror, "assets_group",i));
											break;
	
											
											default :
												out.println("<td class=\"listgensell\">" + vDataExcel.elementAt(i) + "</td>");
												break;
	
										}// End switch column
										if(stserror)
											vectErr.add(arrErrMessage);
									} // End for(int i = iAmountColoumn; i<vDataExcel.size(); i++)
								break;
								
                           }// End switch file type
						}

						out.println("</tr></table>");
						out.println("</td></tr></table>");

						out.println("<table><tr><td>");
						out.println("<input type=\"submit\" value=\" Upload Data \">");
						out.println("</td></tr></table>");

						out.println("</form>");
						objByteArrayInputStream.close();

					}catch (Exception e){
						System.out.println("---===Error : " + e.toString());
					}
										
					%>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td height="100%"> 
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>