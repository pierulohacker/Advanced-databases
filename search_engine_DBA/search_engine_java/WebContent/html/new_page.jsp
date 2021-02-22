<!DOCTYPE HTML>
<html>
<head>
<title>Admin | new page</title>
<meta charset="utf-8">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" type = "text/css" href="../css/style.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js" type="text/javascript"></script>
</head>
<body>
<header>
<jsp:include page="reusables/navbar.jsp"/>
</header>
<section id="home-head" class="work">
  <h1>Insert new page</h1>
</section>
<section id="main-content">
  <div class="text-intro">
    <h2>Create a new page with url and title</h2>
  </div>
  <div class="columns">
    <form action="http://localhost:8080/search_engine_java/central_servlet" method = "POST">
  <div class="form-group" >
    <label for="exampleInputEmail1">Url</label>      
    <input type="text" class="form-control" id="email" name="new_page_url" aria-describedby="emailHelp" required placeholder="Title">
    
    <label for="exampleInputEmail1">Title</label>      
    <input type="text" class="form-control" id="email" name="new_page_title" aria-describedby="emailHelp" required placeholder="Title">
    
  </div>
  <input type="hidden" value = "3" name = "idreq">
  
  <button type="submit" class="btn btn-primary">Submit</button>
</form>
  </div>
</section>
<footer>
  <div class="copyright"><small>Copyright. All Rights Reserved | by <a target="_blank" rel="nofollow" href="http://www.iamsupview.be">Supview</a>.</small></div>
</footer>
</body>
</html>