
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="30%">
      <div align="left"><b><img src="<%=approot%>/image/aiso.gif"></b></div>
    </td>
    <td width="40%"><%if(!strInformation.equals("stop")){%><div align="center"><font color="#FF0000" size="4" face="Arial, Helvetica, sans-serif" ID=WRNG></font></div><div align="center"><font color="#FFFFFFF" size="2" face="Arial, Helvetica, sans-serif"><strong><%=strInformation%></strong></font></div><%}%></td>
    <%
        if(!strInformation.equals("stop")){
        %>
    <SCRIPT LANGUAGE="JavaScript">
    var message="Warning !!! ";
    var speed=1000;
    var visible=0;
    function Flash() {
        if (visible == 0) {
            document.all.WRNG.innerHTML = message;
            visible=1;
        } else {
            document.all.WRNG.innerHTML = "&nbsp;";
            visible=0;
        }
        setTimeout('Flash()', speed);
    }
    Flash();
    </SCRIPT>
    <%}%>
    <td width="30%">
      <div align="right"><b><img src="<%=approot%>/image/client.gif"></b></div>
	</td>
  </tr>
</table>
