<!DOCTYPE HTML>
<html>
<head>
<title>White Edition | Projects</title>
<meta charset="utf-8">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<link rel="stylesheet" type = "text/css" href="../css/style.css">
</head>
<body>
<header>
<jsp:include page="reusables/navbar.jsp"/>
</header>

<section id="home-head" class="work">
  <h1>Reserved Area</h1>
</section>
<section id="main-content">
  <div class="text-intro">
    <h2>Login</h2>
  </div>
  <div class="columns">
    <form action="http://localhost:8080/search_engine_java/central_servlet" method = "POST">
  <div class="form-group" >
    <label for="exampleInputEmail1">Admin email</label>
    <input type="text" class="form-control" id="admin" name="admin" aria-describedby="emailHelp" required placeholder="email">
  </div>
  <input type="hidden" value = "2" name = "idreq">
  <div class="form-group">
    <label for="exampleInputPassword1">Password</label>
    <input type="password" class="form-control" id="psw" name="psw"  required placeholder="Password">
  </div>
  <button type="submit" class="btn btn-primary">Submit</button>
</form>
  </div>
</section>
<footer>
  <div class="copyright"><small>Copyright. All Rights Reserved | by <a target="_blank" rel="nofollow" href="http://www.iamsupview.be">Supview</a>.</small></div>
</footer>
</body>
</html>