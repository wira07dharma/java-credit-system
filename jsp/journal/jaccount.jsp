<%@ page language="java" %>

<%@ include file = "../main/javainit.jsp" %>

<%@ page import = "com.dimata.util.*,
                   com.dimata.aiso.session.jurnal.SessJurnal" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.system.*" %>

<%
// get user department from data custom
Vector vDepartmentOid = new Vector(1,1);
Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0)
{
	int iDataCustomCount = vUsrCustomDepartment.size();
	for(int i=0; i<iDataCustomCount; i++)
	{
		DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
		vDepartmentOid.add(objDataCustom.getDataValue());
	}
}

//Vector listAllCode = AppValue.getAppValueVector(PstPerkiraan.ACC_GROUP_ALL);
//Vector listAllCode = AppValue.getAppValueVector(PstPerkiraan.ACC_GROUP_ALL, vUsrDepartment);
Vector listAllCode = AppValue.getAppValueVector(vDepartmentOid, PstPerkiraan.ACC_GROUP_ALL);

Vector vectVal = new Vector(1,1);
vectVal.add(""+PstPerkiraan.ACC_GROUP_ALL);
vectVal.add(""+PstPerkiraan.ACC_GROUP_CASH);
vectVal.add(""+PstPerkiraan.ACC_GROUP_BANK);
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
    var prev = parent.frames[1].document.frmjournal.command.value;
	parent.frames[1].document.frmjournal.detail_id.value=detailId;
	parent.frames[1].document.frmjournal.account_group.value=accGroup;
	parent.frames[1].document.frmjournal.perkiraan.value=idAccount;
	parent.frames[1].document.frmjournal.index.value=index;
	parent.frames[1].document.frmjournal.command.value="<%=Command.EDIT%>";
	parent.frames[1].document.frmjournal.prev_command.value=prev;
	parent.frames[1].document.frmjournal.target="_self";
	parent.frames[1].document.frmjournal.action="jdetail.jsp";
	parent.frames[1].document.frmjournal.submit();
}

// This function will accur when user change ACCOUNT_GROUP combobox
function cmdChange()
{
	var n = parent.frames[1].document.frmjournaldetail.ACCOUNT_GROUP.value;
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
			 for(var j=parent.frames[1].document.frmjournaldetail.ID_PERKIRAAN.length-1; j>-1; j--)
			 {
				parent.frames[1].document.frmjournaldetail.ID_PERKIRAAN.options.remove(j);
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
				
				var oOption = parent.frames[1].document.createElement("OPTION");
				oOption.value = "<%=perkiraan.getOID()%>";
				oOption.text = "<%=space+perkiraan.getNoPerkiraan()+"    "+strAccountName%>";
				parent.frames[1].document.frmjournaldetail.ID_PERKIRAAN.add(oOption);						
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
    var prev = parent.frames[1].document.frmjournaldetail.command.value;
    var prevId = parent.frames[1].document.frmjournaldetail.perkiraan.value;
    var prevIdx = parent.frames[1].document.frmjournaldetail.index.value;

	parent.frames[1].document.frmjournaldetail.detail_id.value=detailId;
    parent.frames[1].document.frmjournaldetail.is_detail_shared.value="false";
    parent.frames[1].document.frmjournaldetail.is_detail_prev_shared.value="false";
	parent.frames[1].document.frmjournaldetail.account_group.value=accGroup;
	parent.frames[1].document.frmjournaldetail.perkiraan.value=idAccount;
    parent.frames[1].document.frmjournaldetail.prev_perkiraan.value=prevId;
	parent.frames[1].document.frmjournaldetail.index.value=index;
    parent.frames[1].document.frmjournaldetail.prev_index.value=prevIdx;
	parent.frames[1].document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	parent.frames[1].document.frmjournaldetail.prev_command.value=prev;
	parent.frames[1].document.frmjournaldetail.action="jdetail.jsp";
	parent.frames[1].document.frmjournaldetail.submit();
}

// This function will occur when user choose a general account
function cmdChooseGeneralAcc(accGroup,detailId,idAccount,index)
{
	parent.frames[1].document.frmjournaldetail.detail_id.value=detailId;
	parent.frames[1].document.frmjournaldetail.account_group.value=accGroup;
	parent.frames[1].document.frmjournaldetail.perkiraan.value=idAccount;
	parent.frames[1].document.frmjournaldetail.index.value=index;
	parent.frames[1].document.frmjournaldetail.action="jdetail.jsp";
	parent.frames[1].document.frmjournaldetail.submit();
}

// this function occur when user change account list combobox
function cmdChangeAccount()
{
	  var selVal = Math.abs(parent.frames[1].document.frmjournaldetail.ID_PERKIRAAN.value);
	  var debitValDefault = parent.frames[1].document.frmjournaldetail.DEBET.defaultValue;
	  var creditValDefault = parent.frames[1].document.frmjournaldetail.KREDIT.defaultValue;
      var isDetailShared = parent.frames[1].document.frmjournaldetail.is_detail_shared.value;
      var prev = parent.frames[1].document.frmjournaldetail.command.value;
      var idx = parent.frames[1].document.frmjournaldetail.index.value;
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
                                parent.frames[1].document.frmjournaldetail.DEBET.value = debitValDefault;
								parent.frames[1].document.frmjournaldetail.KREDIT.value = creditValDefault;
								parent.frames[1].document.frmjournaldetail.DEBET.disabled = false;
								parent.frames[1].document.frmjournaldetail.KREDIT.disabled = false;
								if(parent.frames[1].document.all.msgPostable!=null)
								{
								  parent.frames[1].document.all.msgPostable.innerHTML = "";
								}

                                <%
                                if(hashGeneralAcc.containsKey(String.valueOf(oid))){
                                %>
                                    isNeedRefresh = true;
                                <%}
                                %>

                                if((isDetailShared=='true') || (isNeedRefresh==true)){
                                    parent.frames[1].document.frmjournaldetail.account_group.value="<%=p.getAccountGroup()%>";
                                    parent.frames[1].document.frmjournaldetail.perkiraan.value="<%=oid%>";
                                    parent.frames[1].document.frmjournaldetail.is_detail_shared.value = isNeedRefresh;
                                    parent.frames[1].document.frmjournaldetail.is_detail_prev_shared.value = isDetailShared;
                                    parent.frames[1].document.frmjournaldetail.prev_command.value=prev;
                                    parent.frames[1].document.frmjournaldetail.prev_index.value=idx;
                                    parent.frames[1].document.frmjournaldetail.action="jdetail.jsp";
	                                parent.frames[1].document.frmjournaldetail.submit();
                                }
							<%}else{%>
								parent.frames[1].document.frmjournaldetail.DEBET.value = "0";
								parent.frames[1].document.frmjournaldetail.KREDIT.value = "0";
								parent.frames[1].document.frmjournaldetail.DEBET.disabled = true;
								parent.frames[1].document.frmjournaldetail.KREDIT.disabled = true;
								if(parent.frames[1].document.all.msgPostable!=null)
								{
									parent.frames[1].document.all.msgPostable.innerHTML = "<i>cannot process, this account is header / non postable ...</i>";
								}
                                if(isDetailShared=='true'){
                                    parent.frames[1].document.frmjournaldetail.account_group.value="<%=p.getAccountGroup()%>";
                                    parent.frames[1].document.frmjournaldetail.perkiraan.value="<%=oid%>";
                                    parent.frames[1].document.frmjournaldetail.is_detail_shared.value = false;
                                    parent.frames[1].document.frmjournaldetail.is_detail_prev_shared.value = isDetailShared;
                                    parent.frames[1].document.frmjournaldetail.prev_command.value=prev;
                                    parent.frames[1].document.frmjournaldetail.prev_index.value=idx;
                                    parent.frames[1].document.frmjournaldetail.action="jdetail.jsp";
	                                parent.frames[1].document.frmjournaldetail.submit();
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
