<table width="100%" border="0" bgcolor="#FFFFFF" height="100%">
              <tr> 
                <td> 
                  <table width="110" border="0" cellspacing="0" cellpadding="0" class="menuleft" height="100%">
  <tr> 
    <td colspan="2"> 
      <div class="dtree"> 
        <script type="text/javascript">
		<!--
		
		d = new dTree('d');
		d.config.target="";//"dtree";		
		d.add(0,-1,'AISO Menu')
		
		d.add(50,0,'Cash  ','javascript: d.o(50)');
		d.add(51,50,'Payment','<%=approot%>/journal/journals.jsp');
		d.add(52,50,'Receive','<%=approot%>/journal/journals.jsp');

		d.add(60,0,'Bank','javascript: d.o(50)');
		d.add(61,60,'Payment','');
		d.add(62,60,'Receive','<%=approot%>/journal/journals.jsp');

		d.add(100,0,'Journal','javascript: d.o(100)');
		d.add(101,100,'General',"javascript:setMainFrameUrl('<%=approot%>/journal/journals.jsp')");
		d.add(102,100,'Generate','<%=approot%>/journal/journals.jsp');
		d.add(103,100,'IJ Journals','<%=approot%>/journal/journals.jsp');
		
		d.add(200,0,'Activa','javascript: d.o(200)');
		d.add(201,200,'Order','');
		d.add(202,200,'Receive','');
		d.add(203,200,'Sale','');
		d.add(204,200,'Depreciation','');
		d.add(205,200,'Report PnL','');
		d.add(206,200,'Report Depr.','');
		
		d.add(300,0,'Receivable','javascript: d.o(300)');
		d.add(301,300,'Entry A/P','');
		d.add(301,300,'A/P Payment','');
		d.add(302,300,'Report Sum.','');
		d.add(303,300,'Report Detail','');

		d.add(400,0,'Payable','javascript: d.o(400)');
		d.add(401,400,'Entry A/R','');
		d.add(401,400,'A/R Payment','');
		d.add(402,400,'Report Sum.','');
		d.add(403,400,'Report Detail','');

		d.add(500,0,'Reports','javascript: d.o(400)');
		d.add(501,500,'Cashflow','');
		d.add(501,500,'Profit/Loss','');
		d.add(502,500,'Balance Sht.','');
		d.add(503,500,'Gen. Ledger','');
		d.add(504,500,'Trial Balance','');
		d.add(505,500,'Worksheet','');


		document.write(d);
		d.closeAll();

		//-->
	</script>
      </div>
    </td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="100%" width="17%" align="right">&nbsp; </td>
    <td height="100%" width="83%">&nbsp;</td>
  </tr>
</table>
                </td>
              </tr>
            </table>
          
