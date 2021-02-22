<%@page language="java" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@ page
	import="java.sql.*, java.util.*, java.net.*, 
   oracle.jdbc.*, oracle.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Results</title>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="../css/style.css">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="http://localhost:8080/Cinemas/css/style.css">
</head>
<body>
	<%
		LinkedList<String> url_results_list = (LinkedList<String>) session.getAttribute("url_results_list");
	%>
	<header>
	<jsp:include page="reusables/navbar.jsp"/>
	</header>
	<section id="main-content">
	<div class="text-intro">
		<h1>These are the results of your query</h1>
	</div>
	<ul>
		<%
			for (String url : url_results_list) {
		%>
		<li><a
			href=<%out.println("http://localhost:8080/search_engine_java/central_servlet?url_to_show=" + url + "&idreq=4");%>>
				<%
					out.println(url);
				%>
		</a></li>
		<%
			}
		%>
	</ul>

	</section>
</body>
</html>