<!DOCTYPE HTML>
<html>
<head>
<title>White Edition | Projects</title>
<meta charset="utf-8">
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>

<link rel="stylesheet" type="text/css" href="../css/style.css">
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"
	type="text/javascript"></script>
</head>
<body>
	<header>
		<jsp:include page="reusables/navbar.jsp"/>

	</header>
	<section id="home-head" class="work">
		<h1>Insert new film</h1>
	</section>
	<section id="main-content">
		<div class="text-intro">
			<h2>Insert the information about the film</h2>
		</div>
		<div class="columns">
			<form
				action="http://localhost:8080/search_engine_java/central_servlet"
				method="POST">
				<div class="form-group">
					<label for="exampleInputEmail1">Name</label> <input type="text"
						class="form-control" id="email" name="name"
						aria-describedby="emailHelp" required placeholder="Name">
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Surname</label> <input type="text"
						class="form-control" id="email" name="surname"
						aria-describedby="emailHelp" required placeholder="Surname">
				</div>

				<div class="form-group">
					<label for="exampleInputEmail1">email</label> <input type="text"
						class="form-control" id="email" name="email"
						aria-describedby="emailHelp" required
						placeholder="example@mail.com">
				</div>
				<input type="hidden" value="7" name="idreq">
				<div class="form-group">
					<label for="exampleInputPassword1">Password</label> <input
						type="password" class="form-control" id="psw" name="psw">
				</div>

				<button type="submit" class="btn btn-primary">Submit</button>
			</form>
		</div>
	</section>

</body>
</html>