<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Items</title>
<script type="text/javascript">  
function validate(thisform)  {
	var search = thisform.key.value;
	var flag = false;
	
   if(search == "camera")
	   {
	   		flag = true; 
	   }
	
   if(!flag)
	   	    alert("Please enter a valid product... For Demo purpose: camera");
	    
   return flag;
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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<form name="main"  action="SearchingServlet" onsubmit="return validate(this);">

<table align="center">

<tr><td>

<input type="text" size="40" name="key"></input>

<input type="submit" value="Search" ></input></td></tr>
</table>
</form>


</font>
</body>

</html>
