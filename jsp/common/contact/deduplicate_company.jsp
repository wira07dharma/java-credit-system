<%@ page language="java" %>
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "java.util.*" %>

<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<%//@ page import = "com.dimata.prochain.entity.admin.*" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_PERSONNEL); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
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
public static String strTitle[][] = {
	{"No","Terpakai","Pilih","Kode","Nama Perusahaan","Nama Kontak","Telepon","Alamat"},	
	{"No","Used","Selected","Code","Company Name","Contact Name","Phone","Address"}
};

public static final String masterTitle[] = {
	"Kontak","Contact"	
};

public static final String personTitle[] = {
	"Perseorangan","Personnel"	
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody){
	String result = "";
	if(addBody){
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){	
			result = textJsp[language][index] + " " + prefiks;
		}else{
			result = prefiks + " " + textJsp[language][index];		
		}
	}else{
		result = textJsp[language][index];
	} 
	return result;
}

public String drawListPersonel(int language, Vector objectClass, int start){
	String temp = "";
	String regdatestr = "";
	String address = "";
	
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][0],"2%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"6%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"7%","left","left");	
	ctrlist.dataFormat(strTitle[language][3],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][4],"22%","left","left");
	ctrlist.dataFormat(strTitle[language][5],"22%","left","left");
	ctrlist.dataFormat(strTitle[language][6],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][7],"20%","left","left");

	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	if(start<0)
		start = 0;
								
	for (int i = 0; i < objectClass.size(); i++) {
		 ContactList contact = (ContactList)objectClass.get(i);

		 Vector rowx = new Vector();
		 start = start + 1;
		 
		 rowx.add(String.valueOf(start));		 
		 rowx.add("<input type=\"radio\" name=\"terpakai\" value=\""+contact.getOID()+"\">");		 		 		 		 
		 rowx.add("<input type=\"checkbox\" class=\"formElemen\" name=\"terpilih\" value=\""+contact.getOID()+"\">");		 
		 rowx.add(cekNull(contact.getContactCode())); 
		 rowx.add(cekNull(contact.getCompName()));
		 rowx.add(cekNull(contact.getPersonName())+" "+cekNull(contact.getPersonLastname()));
		 rowx.add(cekNull(contact.getTelpNr()));
		 rowx.add(cekNull(contact.getBussAddress()));
		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(contact.getOID())); 
	}						

	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null)
		val = "";
	return val;	
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
Vector records = new Vector(1,1);
try{ 
	records = (Vector)session.getValue("DEDUPLICATE_COMPANY");
}catch(Exception e){ 
	System.out.println("Exception : "+e.toString());
}


// konstanta command
String strTitle = SESS_LANGUAGE==langForeign ? "Masterdata &gt Merge Company" : "Masterdata &gt Penggabungan Perusahaan";
String strMergeComp = SESS_LANGUAGE==langForeign ? "Company Merge" : "Penggabungan Perusahaan";
String strCloseWindow = SESS_LANGUAGE==langForeign ? "Close" : "Tutup";


if(iCommand==Command.SUBMIT){

	 Vector vectUsed = new Vector(1,1);	 
	 Vector vectSelected = new Vector(1,1);	 	 
	 String[] strUsed = request.getParameterValues("terpakai");
	 String[] strSelected = request.getParameterValues("terpilih");
	 
	 if(strUsed!=null && strUsed.length>0){
		 for(int i=0; i<strUsed.length; i++){        
			try{
				vectUsed.add(new Long(strUsed[i]));				
			}catch(Exception exc){
				System.out.println("err used");
			}
		 }
	 }

	 if(strSelected!=null && strSelected.length>0){
		 for(int i=0; i<strSelected.length; i++){        
			try{
				vectSelected.add(strSelected[i]);				
			}catch(Exception exc){
				System.out.println("err selected");
			}
		 }
	 }
	 	 
	 records = PstContactList.deduplicateContact(vectUsed,vectSelected);	 
}
%>
<!-- End of JSP Block -->
<html>
<head>
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdUpdate(oid){
	document.frmpersonel.command.value="<%=Command.SUBMIT%>";
	document.frmpersonel.action="deduplicate_company.jsp";
	document.frmpersonel.submit();
}

function cmdClose(){
	window.close();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><%=strTitle%></td>
        </tr>
        <tr> 
          <td> 
            <form name="frmpersonel" method="post" action="">
              <input type="hidden" name="command" value="">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table width="100%">
                <tr> 
                  <td><%=drawListPersonel(SESS_LANGUAGE,records,0)%></td>
                </tr>
                <tr> 
                  <td width="46%" nowrap align="left" class="command">&nbsp;
				   <a href="javascript:cmdUpdate()" class="command"><%=strMergeComp%></a> 
				   | <a href="javascript:cmdClose()" class="command"><%=strCloseWindow%></a> 
				  </td>
                </tr>
              </table>
            </form>
            </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
<!-- endif of "has access" condition -->
<%}%>