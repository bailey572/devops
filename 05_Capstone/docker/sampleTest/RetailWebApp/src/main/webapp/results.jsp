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
<title>Fill your cart</title>
<script type="text/javascript">  
function Toggle(flag)  {  
   if(flag)  {  
      
      document.getElementById("results").style.display="block";
      return true;  
   }
   return false;
}  
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
<form name="main" action="selected.jsp">


<%
	ArrayList<String> results = new ArrayList<String>();
	results = (ArrayList<String>) request.getAttribute("res"); 
	if(results != null)
	{
		
		for (String item : results)
		{
			
			if(item.contains("ony")){
			%> 
			<div style="width:800px;height:100px;border:1px solid blue;background-color:#A0C544;font-face:book antiqua">
			<table><tr><td>
			<img src="camera.png" style="width:80px;height:80px"></td><td>
				
				<label>Sony Cybershot 12 MP, Best Buy: 14999, You save: 3999, Optical Zoom: 4x - 32x</label></td><td>
				<input type="checkbox" name="sony">&nbsp;&nbsp;</td><td><label>Add to cart</label></td></table></div>
				<%
			}
			if(item.contains("kon")){
				%> 
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
				<table><tr><td>
				<img src="nikon.jpg" style="width:80px;height:80px"></td><td>
				
				<label>Nikon 16 MP, Best Buy: 16599, You save: 4999, Optical Zoom: 4x - 32x</label></td><td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="nikon">&nbsp;&nbsp;</td><td><label>Add to cart</label></td></table></div>
					
					<%
				}
			if(item.contains("non")){
				%> 
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#A0C544;font-face:book antiqua">
				
				<table><tr><td>
				<img src="canon.jpg" style="width:80px;height:80px"></td><td>
				
				<label>Canon 8MP, Best Buy: 4599, You save: 999, Optical Zoom: 4x - 16x</label></td><td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="canon">&nbsp;&nbsp;</td><td><label>Add to cart</label></td></table></div>
					
					<%
				}
			if(item.contains("dak")){
				%> 
				<div style="width:800px;height:100px;border:1px solid blue;background-color:#FFFAAA;font-face:book antiqua">
				
				<table><tr><td>
				<img src="kodak.jpg" style="width:80px;height:80px"></td><td>
				
				<label>Kodak 8MP, Best Buy: 3999, You save: 499, Optical Zoom: 4x - 16x</label></td><td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" name="kodak">&nbsp;&nbsp;</td><td><label>Add to cart</label></td></table></div>

					
					<%
				}
		}
	}
%>
<br><br>
<input type="submit" value="Checkout" align="middle">
</form>
</font>
</body>
</html>
