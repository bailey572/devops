<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ page language="java" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Your Cart</title>
<script type="text/javascript">  


      </script> 

</head>
<body bgcolor="#121212">
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
<form name="main" action="securepage.jsp">
<font color="#CFECEC">
<table align="center">

<tr><td><label>My Shopping Cart - Free Delivery on this order!!! Hurry!!!</label></td></tr>


</table>
</font>
<%
	String sony = request.getParameter("sony");
	String nikon = request.getParameter("nikon");
	String canon = request.getParameter("canon");
	String kodak = request.getParameter("kodak");
	
	int selected = 0;
	
			
			if(sony != null && sony.equals("on")){
				selected = 1;
				
			%> 
			<input type="hidden" value="sony" name="sony">
			<div style="width:800px;height:100px;border:1px solid blue;background-color:#A0C544;font-face:book antiqua">
			<table cellspacing="10"><tr><td>
			<img src="camera.png" style="width:80px;height:80px"></td><td>
				
				<label>Sony Cybershot 12 MP</td><td>Qty&nbsp;&nbsp;</label> <input type="text" value="1" size="3"></input></td><td>
				Price&nbsp;&nbsp;<input type="text" value="14999" readonly>&nbsp;&nbsp;</td><td><a href="search.jsp">Remove Item</a>
				</td></tr></table></div>
				<%
			}
			if(nikon != null && nikon.equals("on")){
				selected = 1;
				%>
				<input type="hidden" value="nikon" name="nikon"> 
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
				<table cellspacing="10"><tr><td>
				<img src="nikon.jpg" style="width:80px;height:80px"></td><td>
					
					<label>Nikon 16MP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td><td>Qty&nbsp;&nbsp;</label> <input type="text" value="1" size="3"></input></td><td>
				Price&nbsp;&nbsp;<input type="text" value="16599" readonly></td><td><a href="search.jsp">Remove Item</a>
				</td></tr></table></div>
					
					<%
				}
			if(canon != null && canon.equals("on")){
				selected = 1;
				%>
				<input type="hidden" value="canon" name="canon"> 
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#A0C544;font-face:book antiqua">
				<table cellspacing="10"><tr><td>
				<img src="canon.jpg" style="width:80px;height:80px"></td><td>
					
					<label>Canon 8MP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>
					Qty&nbsp;&nbsp;</label> <input type="text" value="1" name="qty" size="3" onblur="calculate(this);"></input></td><td>
				&nbsp;&nbsp;Price&nbsp;&nbsp;<input type="text" value="4599" readonly>&nbsp;&nbsp;<a href="search.jsp">Remove Item</a>
				</td></tr></table></div>
					
					<%
				}
			if(kodak != null && kodak.equals("on")){
				selected = 1;
				%> 
				<input type="hidden" value="kodak" name="kodak">
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
				<table cellspacing="10"><tr><td>
				<img src="kodak.jpg" style="width:80px;height:80px"></td><td>
					
								<label>Kodak 8MP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Qty&nbsp;&nbsp;</label> <input type="text" value="1" size="3"></input></td><td>
				&nbsp;&nbsp;Price&nbsp;&nbsp;<input type="text" value="3999" readonly>&nbsp;&nbsp;<a href="search.jsp">Remove Item</a>
				</td></tr></table></div>
					<%
				}
			if(selected == 1){

	
%>
<br><br>
<input type="submit" value="Proceed with Checkout">
<% }
else
{%>
	<font color="#CFECEC"><label>There are no items in your cart!!!</label></font>
	<%
	}%>
</form>
</font>
</body>
</html>
