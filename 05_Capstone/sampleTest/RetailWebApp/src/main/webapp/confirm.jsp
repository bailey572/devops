<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Order Confirmation</title>
</head>
<body bgcolor="#121212">

<form name="main" onsubmit="return Toggle(true);" action="confirm.jsp" method="post">
<font face="book antiqua">
<div style="width:1400px;height:120px;border:2px solid blue;background-color:#459DEA;">
    <table align="center">
        <tr>
            <td></td>
            <td><h1 align="center">Capstone Project Retail Store</h1></td>
            <td><img src="devopslogo6.png" style="width:200px;height:50px"></td>
        </tr>
    </table>
</div>
</font>
<br>
<br>

<font face="book antiqua" color="#CFECEC">
<a href= "index.jsp"><p align = "right">LogOut</p></a>
<div  style="width:1200px;height:20px;border:2px solid blue;background-color:#459DEA;">
<Font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Thank You For Your Order.</font></div>
<br><br><br>
<%
String mail = request.getParameter("mail");
%>
<table>
<tr><td>
<label>Order Number:</label></td><td><label><%= (int)(Math.random() * 1000) %></label>
</td></tr>
<tr><td>
<script type="text/javascript">

var currentTime = new Date();
</script>

<%
java.util.Date date = new java.util.Date();
if(date!= null)
{
%>
<label>Order Date:</label></td><td><label><%= date.toString() %></label>
<%} %>

</td></tr>
<tr><td>

<label>Customer mail ID:</label></td><td><label><%= mail %></label>

</td></tr>
</table>
<img src="thank_you.jpg" align = "Right" width="225" height="100" alt="Milford Sound in New Zealand">

</form>
</body>
</html>
