<!DOCTYPE HTML>
<html>
<head>
<title>Error</title>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="../css/style.css">
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"
	type="text/javascript"></script>
</head>
<body>
	<header>
<jsp:include page="reusables/navbar.jsp"/>
	</header>
	<section id="video" class="home">
		<h1>Ops!</h1>
	</section>
	<section id="main-content">
		<div class="text-intro">
			<h2>Something went wrong</h2>
			<h3 style="text-align: center">What may have happened?</h3>
		</div>
		<div class="columns features">
			<div class="one-third first">
				<h3>Login Error</h3>
				<p>If you were trying to login, probably you inserted wrong
					credentials</p>
			</div>
			<div class="one-third">
				<h3>Access Denied</h3>
				<p>Probably you were trying to access to some reserved pages.
					Please login first</p>
			</div>
			<div class="one-third">
				<h3>Inserting new data</h3>
				<p>Probably, if you are an employee, you were trying to insert
					some data that are already in the database</p>
			</div>
		</div>
	</section>
	<footer>
		<div class="copyright">
			<small>Copyright. All Rights Reserved | by <a target="_blank"
				rel="nofollow">Paolo Pastore</a>.
			</small>
		</div>
	</footer>
</body>
</html>