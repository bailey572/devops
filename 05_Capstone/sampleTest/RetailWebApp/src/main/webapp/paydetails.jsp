<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Payment Mode</title>
</head>
<body bgcolor="#121212">
<font face="book antiqua">
<div	style="width: 1400px; height: 120px; border: 2px solid blue; background-color: #459DEA;">
	<table align="center">
		<tr>
			<td></td>
			<td><h1 align="center">Capstone Project Retail Store</h1></td>
			<td><img src="devopslogo6.png" style="width:200px;height:50px"></td>
		</tr>
	</table>
</div>
</font>

<form name="main" onsubmit="return Toggle(true);" action="confirm.jsp" method="post">
<font face="book antiqua" color="#CFECEC">
<%
      String sony = request.getParameter("sony");
	String nikon = request.getParameter("nikon");
	String canon = request.getParameter("canon");
	String kodak = request.getParameter("kodak");
	String mail = request.getParameter("mail");
	
	
	if(sony != null && sony.equals("sony"))
	{
	%>
	<input type="hidden" value="sony" name="sony">
	<%}
	if(nikon != null && nikon.equals("nikon"))
	{
		%><input type="hidden" value="nikon" name="nikon"><%
	}
	if(canon != null && canon.equals("canon"))
	{
		%><input type="hidden" value="canon" name="canon"><%
	}
	if(kodak != null && kodak.equals("kodak"))
	{
	%><input type="hidden" value="kodak" name="kodak"><%
	}%>
	<input type="hidden" value=<%=mail %> name="mail">
	<br><br>
<div
	style="width: 1000px; height: 20px; border: 2px solid blue; background-color: #459DEA;">
<Font>Payment Mode</font></div>
<table cellspacing="10"><tr><td>
<img src="CreditCardLogos.jpg" alt="Check Out" style="width: 100px; Height: 100px"></td><td>
<input type="radio" name="group1" value="card" CHECKED>
Pay By Credit Card</td></tr>

<tr><td>
<img src="cash-money.jpg" alt="Check Out" style="width: 100px; Height: 100px"></td><td>
<input type="radio" name="group1" value="cash">
Pay By Cash(On Delivery)
</td></tr></table>
<div
	style="width: 1000px; height: 20px; border: 2px solid blue; background-color: #459DEA;">
	
<Font>Credit Card Details</font></div>
<table><tr><td>
<label> Card Type </label></td><td>
<SELECT NAME=List1 STYLE="Width: 150">
	<OPTION Value="">Choose your card</OPTION>
	<OPTION Value="HDFC">HDFC BANK</OPTION>
	<OPTION Value="ICICI">ICICI BANK</OPTION>
</SELECT></td></tr>
<tr><td>
<label> Card Number</label></td><td>
<input type="text"></input></td></tr>
<tr><td>
<label> CVV </label></td><td>
<input type="password" size="3"></input></td></tr>
<tr><td>
<br><br>
<input type="submit" value="Confirm Pay"></input></td></tr>
</table>
</form>
</font>
</body>
</html>
