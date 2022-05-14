<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Check Out Page 2</title>

</head>
<body bgcolor="#121212">
<font face="book antiqua">
<div style="width: 1400px; height: 120px; border: 2px solid blue; background-color: #459DEA;">
	<table align="center">
		<tr>
			<td></td>
			<td><h1 align="center">Capstone Project Retail Store</h1></td>
			<td><img src="devopslogo6.png" style="width:200px;height:50px"></td>
		</tr>
	</table>
</div>
<form name="main" onsubmit="return Toggle(true);" action="paydetails.jsp" method="post">
<br>
<img src="chkout.jpg"
	alt="Check Out">
<Font size="5" color="#CFECEC">Review Items and Confirm Pay</Font>
<br>
<div
	style="width: 1000px; height: 20px; border: 2px solid blue; background-color: #459DEA;">
<label>Review Items to Confirm Pay</label></div>
<%
	int total = 0;
      String sony = request.getParameter("sony");
	String nikon = request.getParameter("nikon");
	String canon = request.getParameter("canon");
	String kodak = request.getParameter("kodak");
	String mail = request.getParameter("mail");
	
	if(sony != null && sony.equals("sony")){
		
		
		total += 14999;
	%> 
	<input type="hidden" value="sony" name="sony">
	<div style="width:900px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
	<table cellspacing="10"><tr><td>
	<img src="camera.png" style="width:80px;height:80px"></td><td>
		
		<label>Sony Cybershot 12 MP, Best Buy: 14999, You save: 3999, Optical Zoom: 4x - 32x&nbsp;&nbsp;Qty: 1&nbsp;&nbsp;</label> 
		&nbsp;&nbsp;Price:14999&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table></div>
		<%
	}
if(nikon != null && nikon.equals("nikon")){
		
		
		total += 16599;
	%> 
	<input type="hidden" value="nikon" name="nikon">
	<div style="width:900px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
	<table cellspacing="10"><tr><td>
	<img src="nikon.jpg" style="width:80px;height:80px"></td><td>
		
		<label>Nikon 16 MP, Best Buy: 16599, You save: 4999, Optical Zoom: 4x - 32x
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Qty: 1&nbsp;&nbsp;</label> 
		&nbsp;&nbsp;Price:16599&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table></div>
		<%
	}
if(canon != null && canon.equals("canon")){
	
	
	total += 4599;
%> 
<input type="hidden" value="canon" name="canon">
<div style="width:900px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
<table cellspacing="10"><tr><td>
<img src="canon.jpg" style="width:80px;height:80px"></td><td>
	
	<label>Canon 8MP, Best Buy: 4599, You save: 999, Optical Zoom: 4x - 16x&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Qty: 1&nbsp;&nbsp;</label> 
	&nbsp;&nbsp;Price:4599&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table></div>
	<%
}
if(kodak != null && kodak.equals("kodak")){
	
	
	total += 3999;
%> 
<input type="hidden" value="kodak" name="kodak">
<div style="width:900px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
<table cellspacing="10"><tr><td>
<img src="kodak.jpg" style="width:80px;height:80px"></td><td>
	
	<label>Kodak 8MP, Best Buy: 3999, You save: 499, Optical Zoom: 4x - 16x&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	Qty: 1&nbsp;&nbsp;</label> 
	&nbsp;&nbsp;Price:3999&nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table></div>
	<%
}
	%>


<div
	style="width: 300px; height: 100px; border: 2px solid blue; background-color: #459DEA;">
<table><tr><td>
<label>Sub Total </label></td><td><input type="text" value=<%=total %> readonly="readonly"></td></tr>
<tr><td>
<label>Delivery</label></td><td><input type="text"value="0" readonly="readonly"></td></tr>
<tr><td>
<label>Total</label></td><td><input type="text" value=<%=total %> readonly="readonly"></td></tr>
	</table>
	</div>
<br></br>
<input type="hidden" value=<%=mail %> name="mail">
<input type="submit" value="Confirm Order"></input>
</form>
</font>
</body>
</html>
