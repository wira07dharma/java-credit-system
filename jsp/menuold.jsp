		<!--
		
		//var status = false;
		
		/*d = new dTree('d');
		d.config.target="";//"dtree";		
		d.add(0,-1,'<%=strMenuNames[SESS_LANGUAGE][0]%>',"javascript: d.oAll('true')");
		
		d.add(40,0,'<%=strMenuNames[SESS_LANGUAGE][1]%>',"javascript:setMainFrameUrl('<%=approot%>/homexframe.jsp')");
		
		d.add(50,0,'<%=strMenuNames[SESS_LANGUAGE][2]%>','javascript: d.o(2)');
		d.add(51,50,'<%=strMenuNames[SESS_LANGUAGE][3]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashreceipts/journalsearch.jsp')");		
		d.add(52,50,'<%=strMenuNames[SESS_LANGUAGE][5]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycash/journalsearch.jsp')");

		d.add(60,0,'<%=strMenuNames[SESS_LANGUAGE][6]%>','javascript: d.o(5)');
		d.add(61,60,'<%=strMenuNames[SESS_LANGUAGE][7]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdeposite/journalsearch.jsp')");
		d.add(62,60,'<%=strMenuNames[SESS_LANGUAGE][8]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/bankdraw/journalsearch.jsp')");
		d.add(63,60,'<%=strMenuNames[SESS_LANGUAGE][9]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/pettycashreplacement/journalsearch.jsp')");
		d.add(64,60,'<%=strMenuNames[SESS_LANGUAGE][10]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/banktransfer/journalsearch.jsp')");
		d.add(65,60,'<%=strMenuNames[SESS_LANGUAGE][4]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/cashpayment/journalsearch.jsp')");
		d.add(66,60,'<%=strMenuNames[SESS_LANGUAGE][33]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/payment/journalsearch.jsp')");

		d.add(70,0,'<%=strMenuNames[SESS_LANGUAGE][11]%>','javascript: d.o(12)');
		d.add(71,70,'<%=strMenuNames[SESS_LANGUAGE][11]%>',"javascript:setMainFrameUrl('<%=approot%>/specialjournal/noncash/journalsearch.jsp')");
		
		d.add(100,0,'<%=strMenuNames[SESS_LANGUAGE][12]%>','javascript: d.o(14)');
		d.add(101,100,'<%=strMenuNames[SESS_LANGUAGE][12]%>',"javascript:setMainFrameUrl('<%=approot%>/journal/journals.jsp')");*/
		/*d.add(102,100,'Generate',"javascript:setMainFrameUrl('<%=approot%>/ij/engine/ij_journal_process.jsp')");
		d.add(103,100,'IJ Journals',"javascript:setMainFrameUrl('<%=approot%>/ij/engine/src_ij_journal.jsp')");
		
		d.add(200,0,'Fix and Other Assets','javascript: d.o(13)');
		d.add(201,200,'Order',"javascript:setMainFrameUrl('<%=approot%>/aktiva/order_aktiva_search.jsp')");
		d.add(202,200,'Receive',"javascript:setMainFrameUrl('<%=approot%>/aktiva/receive_aktiva_search.jsp')");
		d.add(203,200,'Sale',"javascript:setMainFrameUrl('<%=approot%>/aktiva/selling_aktiva_search.jsp')");
		d.add(204,200,'Depreciation',"javascript:setMainFrameUrl('<%=approot%>/aktiva/penyusutan_aktiva.jsp')");
		d.add(205,200,'P/L Asset Selling',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/labarugi_aktiva.jsp')");
		d.add(206,200,'Fix Asset Report',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/aktiva_dan_penyusutannya.jsp')");
		d.add(207,200,'Other Asset Report',"javascript:setMainFrameUrl('<%=approot%>/report/aktiva/aktiva_lain_dan_penyusutannya.jsp')");
		
		d.add(300,0,'Account Receivable','javascript: d.o(21)');
		d.add(301,300,'A/R Entry',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp')");
		d.add(301,300,'A/R Payment',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?arap_type=1')");
		d.add(302,300,'A/R Summary Report',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_search.jsp')");
		d.add(303,300,'A/R Detail Report',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp')");

		d.add(400,0,'Account Payable','javascript: d.o(26)');
		d.add(401,400,'A/P Entry',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_entry_search.jsp')");
		d.add(401,400,'A/P Payment',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp?arap_type=1')");
		d.add(402,400,'A/P Summary Report',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_search.jsp')");
		d.add(403,400,'A/P Detail Report',"javascript:setMainFrameUrl('<%=approot%>/arap/arap_report_detail_search.jsp')");*/

		/*d.add(500,0,'<%=strMenuNames[SESS_LANGUAGE][13]%>','javascript: d.o(16)');
		d.add(501,500,'<%=strMenuNames[SESS_LANGUAGE][14]%>',"javascript:setMainFrameUrl('<%=approot%>/report/cash_flow_dept.jsp')");
		d.add(501,500,'<%=strMenuNames[SESS_LANGUAGE][15]%>',"javascript:setMainFrameUrl('<%=approot%>/report/profit_loss_dept.jsp')");
		d.add(502,500,'<%=strMenuNames[SESS_LANGUAGE][16]%>',"javascript:setMainFrameUrl('<%=approot%>/report/balance_sheet_dept.jsp')");
		d.add(503,500,'<%=strMenuNames[SESS_LANGUAGE][17]%>',"javascript:setMainFrameUrl('<%=approot%>/report/general_ledger_dept.jsp')");
		d.add(504,500,'<%=strMenuNames[SESS_LANGUAGE][18]%>',"javascript:setMainFrameUrl('<%=approot%>/report/trial_balance_dept.jsp')");
		d.add(505,500,'<%=strMenuNames[SESS_LANGUAGE][19]%>',"javascript:setMainFrameUrl('<%=approot%>/report/worksheet_dept.jsp')");

		d.add(600,0,'<%=strMenuNames[SESS_LANGUAGE][20]%>','javascript: d.o(23)');
		d.add(601,600,'<%=strMenuNames[SESS_LANGUAGE][21]%>',"javascript:setMainFrameUrl('<%=approot%>/period/setup_period.jsp')");
		d.add(602,600,'<%=strMenuNames[SESS_LANGUAGE][22]%>',"javascript:setMainFrameUrl('<%=approot%>/period/close_book.jsp')");
		
		d.add(700,0,'<%=strMenuNames[SESS_LANGUAGE][23]%>','javascript: d.o(26)');
		d.add(701,700,'<%=strMenuNames[SESS_LANGUAGE][21]%>',"javascript:setMainFrameUrl('<%=approot%>/period/setup_activity_period.jsp')");
		d.add(702,700,'<%=strMenuNames[SESS_LANGUAGE][22]%>',"javascript:setMainFrameUrl('<%=approot%>/period/close_activity_period.jsp')");
		
		d.add(800,0,'<%=strMenuNames[SESS_LANGUAGE][24]%>','javascript: d.o(29)');
		d.add(801,800,'<%=strMenuNames[SESS_LANGUAGE][25]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_chart.jsp')");
		d.add(802,800,'<%=strMenuNames[SESS_LANGUAGE][26]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/account_link.jsp')");
		d.add(803,800,'<%=strMenuNames[SESS_LANGUAGE][27]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/currencytype.jsp')");
		d.add(804,800,'<%=strMenuNames[SESS_LANGUAGE][28]%>',"javascript:setMainFrameUrl('<%=approot%>/common/payment/standartrate.jsp')");*/
		/*d.add(805,800,'IJ Currency Mapping',"javascript:setMainFrameUrl('<%=approot%>/ij/mapping/ijcurrencymapping.jsp')");
		d.add(806,800,'IJ Payment Mapping',"javascript:setMainFrameUrl('<%=approot%>/ij/mapping/ijpaymentmapping.jsp')");
		d.add(807,800,'IJ Account Mapping',"javascript:setMainFrameUrl('<%=approot%>/ij/mapping/ijaccountmapping.jsp')");
		d.add(808,800,'IJ Location Mapping',"javascript:setMainFrameUrl('<%=approot%>/ij/mapping/ijlocationmapping.jsp')");
		d.add(809,800,'Asset Type',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/jenisaktiva.jsp')");
		d.add(810,800,'Depreciation Type',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/typepenyusutan.jsp')");
		d.add(811,800,'Depreciation Method',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/metodepenyusutan.jsp')");
		d.add(812,800,'Asset Group',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/aktiva_group.jsp')");
		d.add(813,800,'Asset Master Entry',"javascript:setMainFrameUrl('<%=approot%>/masterdata/aktiva/modul_aktiva_search.jsp')");
		d.add(814,800,'Contact',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/srccontact_list.jsp')");
		d.add(815,800,'Contact Class',"javascript:setMainFrameUrl('<%=approot%>/masterdata/contact/contact_class.jsp')");*/
		//d.add(805,800,'<%=strMenuNames[SESS_LANGUAGE][29]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/donorcomp/donor_component.jsp')");
		//d.add(806,800,'<%=strMenuNames[SESS_LANGUAGE][30]%>',"javascript:setMainFrameUrl('<%=approot%>/masterdata/activity/activity.jsp')");
		//d.add(807,800,'Department',"javascript:setMainFrameUrl('<%=approot%>/masterdata/company/department.jsp')");
		//d.add(808,800,'User',"javascript:setMainFrameUrl('<%=approot%>/admin/userlist.jsp')");
		//d.add(809,800,'Group Privilege',"javascript:setMainFrameUrl('<%=approot%>/admin/grouplist.jsp')");
		//d.add(810,800,'Privilege',"javascript:setMainFrameUrl('<%=approot%>/admin/privilegelist.jsp')");
		/*d.add(819,800,'Activity Period Link',"javascript:setMainFrameUrl('<%=approot%>/masterdata/activity/act_prd_link.jsp')");
		d.add(820,800,'Activity Donor Comp Link',"javascript:setMainFrameUrl('<%=approot%>/masterdata/activity/act_dnc_link.jsp')");*/

		//d.add(900,0,'<%=strMenuNames[SESS_LANGUAGE][31]%>',"javascript:setMainFrameUrl('<%=approot%>/manual/aiso_manual_english.htm')");
		
		//d.add(1000,0,'<%=strMenuNames[SESS_LANGUAGE][32]%>',"javascript:logOut('<%=approot%>/logout.jsp')");
		
		//document.write(d);
		//d.closeAll();

		//-->
	
