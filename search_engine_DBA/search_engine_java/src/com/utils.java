package com;


import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Objects;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.Active_user;
import models.frequent_keyword;
import oracle.jdbc.OracleTypes;

public class utils {

	public static Connection connect_to_db() throws ClassNotFoundException, SQLException
	{
		String user = "pierpaolo_search_engine_1";
		String pass = "pierpaolo";
		String sid = "orcl";
		String host = "localhost";
		int port = 1521;

		String url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + sid;
		System.out.println(url);
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn = DriverManager.getConnection(url, user, pass);
		System.out.println("Connesso!");
		return conn;
	}
	public static void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String email = null;
		try 
		{
			Connection conn = connect_to_db();
			System.out.println("Connesso!");
			CallableStatement cstmt = conn.prepareCall("{? = call login(?,?)}");
			cstmt.registerOutParameter(1, Types.NUMERIC); //numero di output
			email=request.getParameter("email");
			cstmt.setString(2, email);
			cstmt.setString(3, request.getParameter("psw"));
			cstmt.executeUpdate();
			int user_id = cstmt.getInt(1);			

			HttpSession session=request.getSession();
			session.setAttribute("email", email); //setto la variabile di sessione
			session.setAttribute("user_id", user_id);
			System.out.println(session.getAttribute("email"));
			response.sendRedirect("http://localhost:8080/search_engine_java/html/login_success.jsp");

		}
		catch(ClassNotFoundException e){
			throw new ServletException(e);
		}
		catch(SQLException e){ //quando non trova l'utente la query solleva un'eccezione che gestiamo
			if (e.getErrorCode()==1403){
				System.out.println("Utente non trovato!");
				response.sendRedirect("http://localhost:8080/search_engine_java/html/error_page.jsp");	
			}
			else //eccezione imprevista
				throw new ServletException(e);
		}
	}

	/**
	 * Gestito localmente senza intaccare il db, solo a scopo di test.
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	public static void admin_login(HttpServletRequest request, HttpServletResponse response) throws IOException{
		HttpSession session = request.getSession();
		String adm;
		String psw;
		adm = request.getParameter("admin");
		psw = request.getParameter("psw");
		if (Objects.equals(adm,"admin") && Objects.equals(psw, "admin"))
		{
			session.setAttribute("admin", adm);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/login_success.jsp");;
		}
		else
		{
			System.out.println("Errore, hai inserito utente: " + adm + " pass: " + psw);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/error_page.jsp");
		}

	}

	public static void logout(HttpServletRequest request, HttpServletResponse response) throws IOException{
		HttpSession session = request.getSession();
		session.setAttribute("email", null);
		session.setAttribute("admin", null);
		session.setAttribute("session_id", null);
		session.setAttribute("user_id", null);
		response.sendRedirect("http://localhost:8080/search_engine_java/html/index.jsp");
	}

	/**
	 * Permette di inserire una nuova pagina nel search engine; in oracle i triggers e le procedure implementate permettono l'indicizzazione
	 * dei termini presenti nella page
	 * @param request
	 * @param response
	 * @throws IOException
	 * @throws ServletException
	 */
	public static void insert_new_page(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		HttpSession session = request.getSession();
		String admin_session_string;
		admin_session_string = (String) session.getAttribute("admin");
		if (Objects.equals(admin_session_string, "admin"))
		{
			try {
				Connection conn = connect_to_db();
				CallableStatement cstmt = conn.prepareCall("{call new_page(?,?)}");
				cstmt.setString(1, request.getParameter("new_page_url"));
				cstmt.setString(2, request.getParameter("new_page_title"));
				cstmt.executeUpdate();
				response.sendRedirect("http://localhost:8080/search_engine_java/html/operation_success.jsp");
			}		
			catch(SQLException e){
				if(e.getErrorCode()==00001)
				{
					System.out.println("ERRORE: Pagina già esistente");
					response.sendRedirect("http://localhost:8080/search_engine_java/html/error_page.jsp");
				}
				else
					throw new ServletException(e);
			} 
			catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
		else //misura di sicurezza qualora si fosse nella pagina senza essere passati per il login
		{
			response.sendRedirect("http://localhost:8080/search_engine_java/html/error_page.jsp");
		}

	}


	/**
	 * Creazione di un nuovo utente mediante credenziali, se l'utente non esiste già ci permette di alterare la sessione inserendo la sua mail
	 * @param request
	 * @param response
	 * @throws IOException
	 * @throws ServletException
	 */
	public static void register_user(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			Connection conn = connect_to_db();
			HttpSession session = request.getSession();
			String name = request.getParameter("name");
			String surname = request.getParameter("surname");
			String email = request.getParameter("email");
			String password = request.getParameter("psw");

			CallableStatement cstmt = conn.prepareCall("{? = call new_registered_user(?,?,?,?)}");
			cstmt.registerOutParameter(1, Types.NUMERIC); //numero di output
			cstmt.setString(2, name);
			cstmt.setString(3, surname);
			cstmt.setString(4, email);
			cstmt.setString(5, password);
			cstmt.executeUpdate();
			int user_id = cstmt.getInt(1);
			session.setAttribute("user_id", user_id);
			session.setAttribute("email", email);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/login_success.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			if(e.getErrorCode()==20010)
			{
				response.sendRedirect("http://localhost:8080/search_engine_java/html/error_page.jsp");
				System.out.println("ERRORE: Email already registered");
			}
			else
				throw new ServletException(e);

		}		
	}

	/**
	 * Viene eseguito "silenziosamente" quando un utente che non ha fatto il login esegue direttamente una query
	 * @param request
	 * @param response
	 * @throws IOException
	 * @throws ServletException
	 */
	//TODO: forse da rendere private e per usarlo come metodo di servizio in un if nel metodo run_search_query
	public static void uknown_user_creation(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		try {
			Connection conn = connect_to_db();
			HttpSession session = request.getSession();

			CallableStatement cstmt = conn.prepareCall("{? = call new_unknown_user()}");
			cstmt.registerOutParameter(1, Types.NUMERIC); //numero di output
			cstmt.executeUpdate();
			int user_id = cstmt.getInt(1);
			session.setAttribute("user_id", user_id);
			System.out.println("nuovo utente anonimo con id: " + user_id);
			//response.sendRedirect("http://localhost:8080/search_engine_java/html/login_success.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		
	}

	public static void run_search_query(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		String search_keyword = request.getParameter("search_keyword");
		try {
			LinkedList<String> url_results_list = new LinkedList<>();
			Connection conn = utils.connect_to_db();  
			HttpSession session = request.getSession();
			if (session.getAttribute("user_id")==null)
			{
				uknown_user_creation(request, response);
			}
			int user_id = (int) session.getAttribute("user_id");
			CallableStatement cs;
			Object session_id_ojb = session.getAttribute("session_id");
			if (Objects.equals(session_id_ojb, null))
			{
				String plsql = " declare"+
						" search_keyword search_tab.keyword%type;" + 
						" search_user_id user_tab.user_id%type;" +
						" result_numb number;"+
						" url page_tab.url%type;"+
						" term_ref ref term_t;" +
						" user_ref ref user_t;" +
						" l_rc sys_refcursor;" + 
						" begin" +
						" search_keyword := ? ;" +
						" search_user_id := ? ; " +
						" select count(t.term_name) into result_numb from term_tab t where t.term_name=search_keyword;" +
						" if result_numb >0 then" +
						" select ref(t) into term_ref from term_tab t where t.term_name= search_keyword and rownum=1;" +
						" select ref(u) into user_ref from user_tab u where u.user_id= search_user_id and rownum=1;" +
						" insert into search_tab(keyword, user_associated, term)" +
						" values (search_keyword, user_ref, term_ref) RETURNING code_session into ?;" +

					"    open l_rc for " +
					" select * from (select deref(nt.page).url  from table(select inverted_index from term_tab where term_name=search_keyword) nt order by nt.occurrences) "
					+ "where rownum <= 20;" +
					"    ? := l_rc;" +
					" end if;" +
					" end;";


				cs = conn.prepareCall(plsql);

				cs.setString(1, search_keyword);
				cs.setInt(2, user_id);
				cs.registerOutParameter(3, OracleTypes.NUMBER);	//il code  session appena creato
				cs.registerOutParameter(4, OracleTypes.CURSOR);	
				cs.execute();
				session_id_ojb = cs.getInt(3);
				session.setAttribute("session_id", session_id_ojb);
				System.out.println("Creato un nuovo code_session: " + session_id_ojb);
			}
			else//esiste già un session id per l'utente
			{
				int session_id = (int)session_id_ojb;
				String plsql = " declare"+
						" search_keyword search_tab.keyword%type;" + 
						" search_user_id user_tab.user_id%type;" +
						" result_numb number;"+
						" url page_tab.url%type;"+
						" term_ref ref term_t;" +
						" user_ref ref user_t;" +
						" l_rc sys_refcursor;" + 
						" begin" +
						" search_keyword := ? ;" +
						" search_user_id := ? ; " +
						" select count(t.term_name) into result_numb from term_tab t where t.term_name=search_keyword;" +
						" if result_numb >0 then" +
						" select ref(t) into term_ref from term_tab t where t.term_name= search_keyword and rownum=1;" +
						" select ref(u) into user_ref from user_tab u where u.user_id= search_user_id and rownum=1;" +
						" insert into search_tab(code_session, keyword, user_associated, term)" +
						" values (?, search_keyword, user_ref, term_ref);" +

						"    open l_rc for " +
						" select * from (select deref(nt.page).url  from table(select inverted_index from term_tab where term_name=search_keyword) nt order by nt.occurrences) "
						+ "where rownum <= 20;" +
						"    ? := l_rc;" +
						" end if;" +
						" end;";


				cs = conn.prepareCall(plsql);

				cs.setString(1, search_keyword);
				cs.setInt(2, user_id);
				cs.setInt(3, session_id);
				cs.registerOutParameter(4, OracleTypes.CURSOR);	
				cs.execute();
				System.out.println("code_session riciclato: " + session_id_ojb);
			}

			ResultSet cursorResultSet = (ResultSet) cs.getObject(4);
			String url;
			while (cursorResultSet.next ())
			{
				url = cursorResultSet.getString(1);
				if ( url != null)
					url_results_list.add(url);
			} 
			cs.close();
			System.out.print(url_results_list);
			session.setAttribute("url_results_list", url_results_list);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/show_urls.jsp");

		} 
		catch (NullPointerException e)
		{
			e.printStackTrace();
			response.sendRedirect("http://localhost:8080/search_engine_java/html/error_query.jsp");
			System.out.println ("No results for keyword " + search_keyword);
		}
		catch (ClassNotFoundException e )
		{
			e.printStackTrace();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void show_page (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try {
			Connection conn = connect_to_db();
			HttpSession session = request.getSession();
			int user_id = (int) session.getAttribute("user_id");
			String url = request.getParameter("url_to_show");
			CallableStatement cstmt = conn.prepareCall("{? = call retrieve_text(?,?)}");
			cstmt.registerOutParameter(1, Types.VARCHAR); 
			cstmt.setInt(2, user_id);
			cstmt.setString(3, url);
			System.out.println("user_id: " + user_id + " url_page: " + url);
			cstmt.executeUpdate();
			String text = cstmt.getString(1);
			session.setAttribute("text_to_show", text);
			
			//TODO: prendere i links
			PreparedStatement pst = conn.prepareStatement("select deref(column_value).url  from table(select T.links from page_tab T where T.url = ?)");
			pst.setString(1, url);
			ResultSet res = pst.executeQuery();
			
			int isPresent = 0;
			LinkedList<String> links =  new LinkedList<String>();
			while(res.next()){
				links.add(res.getString(1));
				isPresent++;
			}
			if(isPresent > 0)
				session.setAttribute("links_to_show", links);
			System.out.println("Link della page: " + links);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/show_page.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		
	}

	public static void admin_stats(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		try {
			Connection conn = connect_to_db();
			HttpSession session = request.getSession();			
	
			PreparedStatement pst = conn.prepareStatement("select * from(select user_id, searches_n from user_tab  order by searches_n desc ) where rownum <=10");
			ResultSet res = pst.executeQuery();
	
			LinkedList<Active_user> most_active_users =  new LinkedList<Active_user>();
			while(res.next()){
				most_active_users.add(new Active_user(res.getInt("user_id"), res.getInt("searches_n")));
			}
			System.out.println("Utenti più attivi: " + most_active_users);
			session.setAttribute("most_active_users", most_active_users);
			
			
			//prendo le keyword cercate più di frequente
			PreparedStatement pst1 = conn.prepareStatement("select * from (select keyword, count (keyword) as total_key from search_tab group by keyword order by total_key desc) where rownum <= 10");
			ResultSet res1 = pst1.executeQuery();
	
			LinkedList<frequent_keyword> most_frequent_keywords =  new LinkedList<frequent_keyword>();
			while(res1.next()){
				most_frequent_keywords.add(new frequent_keyword(res1.getString("keyword"), res1.getInt("total_key")));
			}

			System.out.println("Parole più cercate: " + most_frequent_keywords);
			session.setAttribute("most_frequent_keywords", most_frequent_keywords);
			response.sendRedirect("http://localhost:8080/search_engine_java/html/admin_stats_page.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		
	}

}





