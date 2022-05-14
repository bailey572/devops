<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Secure Payment Gateway</title>
<script type="text/javascript">  
function Toggle(flag)  {  
   if(flag)  {  
      document.getElementById("results").style.display="block";
      return true;
   }
   else
   {
	   document.getElementById("results").style.display="none";
	   return false;
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
</div></font>
<form name="main" onsubmit="return Toggle(true);" action="checkout.jsp">
<font face="book antiqua" color="#CFECEC">
<table>

<tr><td>
<div style="width:260px;height:20px;border:2px solid blue;background-color:#459DEA;">
<label>I would like to collect my order at</label></div>
</td></tr>
<tr><td>
<input type="radio" name="group1" value="home" CHECKED>My Door Step</td></tr>
<tr><td>
<input type="radio" name="group1" value="store">Nearby Store</td></tr>
</table>
<table>

<tr><td>
<div style="width:200px;height:20px;border:2px solid blue;background-color:#459DEA;">
<label>Billing Address</label></div>
</td></tr>
<tr><td>
<label>First Name</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="fname"></td></tr>
<tr><td>
<label>Last Name</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="lname"></td></tr>
<tr><td>
<label>Address</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="addr"></td></tr>
<tr><td>
<label>Zipcode</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="zip"></td></tr>
<tr><td>
<label>Phone</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="phone"></td></tr>
<tr><td>
<label>email</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="mail"></td></tr>
</table>
<%
      String sony = request.getParameter("sony");
	String nikon = request.getParameter("nikon");
	String canon = request.getParameter("canon");
	String kodak = request.getParameter("kodak");
	
	
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


<table>
<tr><td>
<div style="width:200px;height:20px;border:2px solid blue;background-color:#459DEA;">
<label>Delivery Address</label></div>
</td></tr>
<tr><td>
<input type="checkbox" name="same">&nbsp;&nbsp;<label>Use billing address</label></td></tr>
<tr><td>
<label>First Name</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="dfname"></td></tr>
<tr><td>
<label>Last Name</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="dlname"></td></tr>
<tr><td>
<label>Address</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="daddr"></td></tr>
<tr><td>
<label>Zipcode</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="dzip"></td></tr>
<tr><td>
<label>Phone</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="dphone"></td></tr>
<tr><td>
<label>email</label>&nbsp;&nbsp;</td><td>
<input type="text" size="30" name="dmail"></td></tr>
</table>
<input type="submit" value="Continue">
</form>
</font>
</body>

</html>
