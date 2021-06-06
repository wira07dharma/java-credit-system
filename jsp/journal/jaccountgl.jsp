<%@ page language="java" %>

<%@ page import = "com.dimata.util.*,
                   com.dimata.aiso.session.jurnal.SessJurnal,
                   java.util.Vector,
                   java.util.Hashtable" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.system.*" %>

<%

//Vector listAllCode = AppValue.getAppValueVector(vDepartmentOid, PstPerkiraan.ACC_GROUP_ALL);

Vector vectVal = new Vector(1,1);
vectVal.add(""+PstPerkiraan.ACC_GROUP_LIQUID_ASSETS);
vectVal.add(""+PstPerkiraan.ACC_GROUP_FIXED_ASSETS); 
vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_ASSETS);
vectVal.add(""+PstPerkiraan.ACC_GROUP_CURRENCT_LIABILITIES);
vectVal.add(""+PstPerkiraan.ACC_GROUP_LONG_TERM_LIABILITIES);
vectVal.add(""+PstPerkiraan.ACC_GROUP_EQUITY);
vectVal.add(""+PstPerkiraan.ACC_GROUP_REVENUE);
vectVal.add(""+PstPerkiraan.ACC_GROUP_COST_OF_SALES);
vectVal.add(""+PstPerkiraan.ACC_GROUP_EXPENSE);
vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_REVENUE);
vectVal.add(""+PstPerkiraan.ACC_GROUP_OTHER_EXPENSE);

Hashtable hashGeneralAcc = SessJurnal.getAllGeneralAccount();
%>

<script language="JavaScript">
// This function will occur when user click href on account name on Jurnal Umum
function cmdClickAccountJu(accGroup,detailId,idAccount,index)
{
    var prev = document.frmjournal.command.value;
	document.frmjournal.detail_id.value=detailId;
	document.frmjournal.account_group.value=accGroup;
	document.frmjournal.perkiraan.value=idAccount;
	document.frmjournal.index.value=index;
	document.frmjournal.command.value="<%=Command.EDIT%>";
	document.frmjournal.prev_command.value=prev;
	document.frmjournal.target="_self";
	document.frmjournal.action="jdetail.jsp";
	document.frmjournal.submit();
}

// This function will accur when user change ACCOUNT_GROUP combobox
function cmdChange()
{
	var n = document.frmjournaldetail.ACCOUNT_GROUP.value;
	switch(n)
	{
	<%
	if(vectVal!=null && vectVal.size()>0)
	{
		for(int i=0; i<vectVal.size(); i++)
		{
			String sVal = String.valueOf(vectVal.get(i));
			Vector listAccount = AppValue.getAppValueVector(vDepartmentOid, Integer.parseInt(sVal)); 		
	%>
		case "<%=sVal%>" :						
			 for(var j=document.frmjournaldetail.ID_PERKIRAAN.length-1; j>-1; j--)
			 {
				document.frmjournaldetail.ID_PERKIRAAN.options.remove(j);
			 }
			 			 
			 <%

             String space = "";
			 String strAccountName = "";			 
			 if(listAccount!=null && listAccount.size()>0)
			 {
				for(int k=0; k<listAccount.size(); k++)
				{ 				 
				   Perkiraan perkiraan = (Perkiraan)listAccount.get(k); 
				   switch(perkiraan.getLevel())
				   {
					   case 1 : space = ""; break; 
					   case 2 : space = "    "; break;
					   case 3 : space = "        "; break;
					   case 4 : space = "            "; break;
					   case 5 : space = "                "; break;
					   case 6 : space = "                    "; break;															    															   															   															   															   
				   }				   
				   strAccountName = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? perkiraan.getAccountNameEnglish() : perkiraan.getNama();				   
				%>
				
				var oOption = document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=space+perkiraan.getNoPerkiraan()+"    "+strAccountName%>";
				document.frmjournaldetail.ID_PERKIRAAN.add(oOption);
				
				<%   
				} 
			 }																												
			 %>
			 break;	
	<%	
		}	
	}
	%>
		default :
			break;
	}
}


// This function will occur when user click href on account name on Jurnal Detail
function cmdClickAccountJd(accGroup,detailId,idAccount,index)
{
    var prev = document.frmjournaldetail.command.value;
    var prevId = document.frmjournaldetail.perkiraan.value;
    var prevIdx = document.frmjournaldetail.index.value;

	document.frmjournaldetail.detail_id.value=detailId;
    document.frmjournaldetail.is_detail_shared.value="false";
    document.frmjournaldetail.is_detail_prev_shared.value="false";
	document.frmjournaldetail.account_group.value=accGroup;
	document.frmjournaldetail.perkiraan.value=idAccount;
    document.frmjournaldetail.prev_perkiraan.value=prevId;
	document.frmjournaldetail.index.value=index;
    document.frmjournaldetail.prev_index.value=prevIdx;
	document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.prev_command.value=prev;
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

// This function will occur when user choose a general account
function cmdChooseGeneralAcc(accGroup,detailId,idAccount,index)
{
	document.frmjournaldetail.detail_id.value=detailId;
	document.frmjournaldetail.account_group.value=accGroup;
	document.frmjournaldetail.perkiraan.value=idAccount;
	document.frmjournaldetail.index.value=index;
	document.frmjournaldetail.action="jdetail.jsp";
	document.frmjournaldetail.submit();
}

// this function occur when user change account list combobox
function cmdChangeAccount()
{
	  var selVal = Math.abs(document.frmjournaldetail.ID_PERKIRAAN.value);
	  var debitValDefault = document.frmjournaldetail.DEBET.defaultValue;
	  var creditValDefault = document.frmjournaldetail.KREDIT.defaultValue;
      var isDetailShared = document.frmjournaldetail.is_detail_shared.value;
      var prev = document.frmjournaldetail.command.value;
      var idx = document.frmjournaldetail.index.value;
      var isNeedRefresh = false;
	  var exist = 0;
	  var jdAccount = 0;
	  var jdIndex = -1;

	  switch(selVal)
	  {
	  <%
	  for(int i=0;i<listAllCode.size();i++)
	  {
		 Perkiraan p = (Perkiraan)listAllCode.get(i);
		 long oid = p.getOID(); 
	  %>
		   case <%=oid%> : <%if(p.getPostable() ==  PstPerkiraan.ACC_POSTED){
                            %>
                                document.frmjournaldetail.DEBET.value = debitValDefault;
								document.frmjournaldetail.KREDIT.value = creditValDefault;
								document.frmjournaldetail.DEBET.disabled = false;
								document.frmjournaldetail.KREDIT.disabled = false;
								if(document.all.msgPostable!=null)
								{
								  document.all.msgPostable.innerHTML = "";
								}

                                <%
                                if(hashGeneralAcc.containsKey(String.valueOf(oid))){
                                %>
                                    isNeedRefresh = true;
                                <%}
                                %>

                                if((isDetailShared=='true') || (isNeedRefresh==true)){
                                    document.frmjournaldetail.account_group.value="<%=p.getAccountGroup()%>";
                                    document.frmjournaldetail.perkiraan.value="<%=oid%>";
                                    document.frmjournaldetail.is_detail_shared.value = isNeedRefresh;
                                    document.frmjournaldetail.is_detail_prev_shared.value = isDetailShared;
                                    document.frmjournaldetail.prev_command.value=prev;
                                    document.frmjournaldetail.prev_index.value=idx;
                                    document.frmjournaldetail.action="jdetail.jsp";
	                                document.frmjournaldetail.submit();
                                }
							<%}else{%>
								document.frmjournaldetail.DEBET.value = "0";
								document.frmjournaldetail.KREDIT.value = "0";
								document.frmjournaldetail.DEBET.disabled = true;
								document.frmjournaldetail.KREDIT.disabled = true;
								if(document.all.msgPostable!=null)
								{
									document.all.msgPostable.innerHTML = "<i>cannot process, this account is header / non postable ...</i>";
								}
                                if(isDetailShared=='true'){
                                    document.frmjournaldetail.account_group.value="<%=p.getAccountGroup()%>";
                                    document.frmjournaldetail.perkiraan.value="<%=oid%>";
                                    document.frmjournaldetail.is_detail_shared.value = false;
                                    document.frmjournaldetail.is_detail_prev_shared.value = isDetailShared;
                                    document.frmjournaldetail.prev_command.value=prev;
                                    document.frmjournaldetail.prev_index.value=idx;
                                    document.frmjournaldetail.action="jdetail.jsp";
	                                document.frmjournaldetail.submit();
                                }
				 		    <%}%>
							break;
	  <%
	  }
	  %>
		  default :	
		  		break;
	  }
}
</script>
