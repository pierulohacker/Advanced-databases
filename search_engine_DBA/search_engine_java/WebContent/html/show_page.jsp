<%@page language="java" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@ page
	import="java.sql.*, java.util.*, java.net.*, 
   oracle.jdbc.*, oracle.sql.*"%>
<!DOCTYPE HTML>
<html>
<head>
<title>PierEngine</title>
<meta charset="utf-8">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
	<%
		LinkedList<String> links_list = (LinkedList<String>) session.getAttribute("links_to_show");
	%>
	<header>
	<jsp:include page="reusables/navbar.jsp"/>
	</header>
	<section id="home-head" class="work">
		<h1>
			<%
				out.println(session.getAttribute("text_to_show"));
			%>
		</h1>

	</section>
	<section id="main-content">
		<div class="text-intro">
			<%
				if (links_list != null) {
			%>
			<h2>Pages linked</h2>
			<ul>
				<%
					for (String url : links_list) {
				%>
				<li><a
					href=<%out.println(
							"http://localhost:8080/search_engine_java/central_servlet?url_to_show=" + url + "&idreq=4");%>>
						<%
							out.println(url);
						%>
				</a></li>
				<%
					}
				%>
				<%
					}
				%>
			</ul>
	</section>

</body>
</html>