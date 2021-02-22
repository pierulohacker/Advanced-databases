<!DOCTYPE HTML>
<html>
<head>
<title>Pierengine Homepage</title>
<meta charset="utf-8">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<header>

<jsp:include page="reusables/navbar.jsp"/>

</header>
<section id="video" class="home">
  <h1>PIERENGINE SEARCH</h1>
</section>

<section id="main-content">
  <div class="text-intro">
    <h2>Run a search query</h2>
  </div>
  <div class="columns">
    <form action="http://localhost:8080/search_engine_java/central_servlet" method = "POST">
  <div class="form-group">
    <label for="exampleInputEmail1">Insert a search keyword</label>
    <input type="text" class="form-control" id="search_keyword" name="search_keyword"  required placeholder="keyword">
    <input hidden name = "idreq" value ="5">
  </div>
  <button type="submit" class="btn btn-primary">Submit</button>
</form>
  </div>
</section>

<section id="main-content">
  <div class="text-intro">
    <h2>About</h2>
  </div>
  <div class="columns features">
  
    <div class="one-third">
      <h3>Author</h3>
      <p>Name: Pierpaolo Masella</p>
    </div>
  </div>
</section>
</body>
</html>