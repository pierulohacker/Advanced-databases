<%@page language="java" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@ page
	import="java.sql.*, java.util.*, java.net.*, 
   oracle.jdbc.*, oracle.sql.*, models.Active_user, models.frequent_keyword"%>
<html lang="ita">
<head>
	<meta charset="utf-8" />
	<title>Admin stats page</title>
	<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
	<link rel="stylesheet" type="text/css" href="../css/admin_stats_page.css">
	<link rel="stylesheet" type = "text/css" href="../css/style.css">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js" type="text/javascript"></script>
</head>
	<%LinkedList<frequent_keyword> keyword_list = (LinkedList<frequent_keyword>) session.getAttribute("most_frequent_keywords");%>
		<% LinkedList<Active_user> users_list = (LinkedList<Active_user>) session.getAttribute("most_active_users");
		System.out.println(users_list);%>

<body>

<header>
<jsp:include page="reusables/navbar.jsp"/>
  </header>
  


<div class="table-title">
<h3>Users with most searches</h3>
</div>
<table class="table-fill">
<thead>
<tr>
<th class="text-left">User_id</th>
<th class="text-left">Number of research</th>
</tr>
</thead>
<tbody class="table-hover">
<%if (users_list!= null){
for (Active_user user : users_list) {%>
<tr>
<td class="text-left"><%out.println(user.getUser_id()); %></td>
<td class="text-left"><%out.println(user.getN_searches()); %></td>
</tr>
<%} }%>
</tbody>
</table>
  	<meta charset="utf-8" />
	<title>Table Style</title>
	<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
</head>

<body>
<div class="table-title">
<h3>List of the most common research</h3>
</div>
<table class="table-fill">
<thead>
<tr>
<th class="text-left">Keyword</th>
<th class="text-left">Times</th>
</tr>
</thead>
<tbody class="table-hover">
<%if (users_list!= null){
for (frequent_keyword key : keyword_list) {%>
<tr>
<td class="text-left"><%out.println(key.getKeyword()); %></td>
<td class="text-left"><%out.println(key.getFrequency()); %></td>
</tr>
<%} }%>

</tbody>
</table>

  </body>