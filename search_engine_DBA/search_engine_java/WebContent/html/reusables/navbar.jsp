 <div id="nav-placeholder">
 <nav class="main-nav">
 <ul>
      <li>
        <ul>
          <li><a href="index.jsp">home</a></li>
          <% if(session.getAttribute("email") == null && session.getAttribute("admin") == null){ %>
          <li><a href="login.jsp">Login</a></li>
          <li><a href="admin.jsp">Reserved Area</a></li>
          <%}else if (session.getAttribute("admin") != null){ %>
          <li><a href="http://localhost:8080/search_engine_java/central_servlet?idreq=3">Admin stats</a></li>
          <li><a href="new_page.jsp">Add a new page</a></li>
          <li><a href="http://localhost:8080/search_engine_java/central_servlet?idreq=2">logout</a></li>
          <%} else{%>
          <li><a href="http://localhost:8080/search_engine_java/central_servlet?idreq=2">logout</a></li>
          <%} %>
        </ul>
      </li>
    </ul>
  </nav>
  </div>