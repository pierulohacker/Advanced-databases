package tests;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.LinkedList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.utils;

import models.Active_user;
import models.frequent_keyword;
import oracle.jdbc.OracleTypes;


public class Connection_testing {

	public static void connection_test() throws ServletException
	{
		String user = "pierpaolo_search_engine_1";
		String pass = "pierpaolo";
		String sid = "orcl";
		String host = "localhost";
		int port = 1521;

		String url = "jdbc:oracle:thin:@" + host + ":" + port + ":" + sid;
		System.out.println(url);
		try 
		{
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(url, user, pass);
			System.out.println("Connesso!");


		}
		catch(ClassNotFoundException e){
			throw new ServletException(e);
		}
		catch(SQLException e){
			throw new ServletException(e);
		}

	}

	public static void login_test() throws ServletException
	{
		String email = "miriamlucialenti451@mail.com"	;
		String psw = "23miriamlucialenti1931";
		try 
		{

			Connection conn = utils.connect_to_db();
			CallableStatement cstmt = conn.prepareCall("{? = call login(?,?)}");
			cstmt.registerOutParameter(1, Types.VARCHAR); //numero di output
			cstmt.setString(2, email);
			cstmt.setString(3, psw);
			cstmt.executeUpdate();
			String user_id = cstmt.getString(1);
			System.out.println("Loggato: " + email + " id: " + user_id);

		}
		catch(ClassNotFoundException e){
			throw new ServletException(e);
		}
		catch(SQLException e){
			if (e.getErrorCode()==1403)//quando non lo trova riceve questo codice da oracle
				System.out.println("Utente non trovato!");

			else		
				throw new ServletException(e);
		}
	};

	public static void test_insert_new_page() throws IOException, ServletException
	{
		String admin_session_string=null;
		admin_session_string = "admin";
		if (admin_session_string == "admin")
		{
			try {
				Connection conn = utils.connect_to_db();
				CallableStatement cstmt = conn.prepareCall("{call new_page(?,?)}");
				cstmt.setString(1, "www.prova.it");
				cstmt.setString(2, "prova");
				cstmt.executeUpdate();
				System.out.println("Inserito con successo!");
			}		
			catch(SQLException e){
				if(e.getErrorCode()==00001)
				{//TODO: inserire pagina di errore pagina esistente
					System.out.println("ERRORE: Pagina già esistente");
				}
				else
					throw new ServletException(e);
			}  
			catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}

	}

	public static void test_register_user() throws IOException {
		try {
			Connection conn = utils.connect_to_db();
			String name = "pierpaolo";
			String surname = "masella";
			String email = "pierpaolo@mail.pier";
			String password = "pierpaolo_psw";

			CallableStatement cstmt = conn.prepareCall("{call new_registered_user(?,?,?,?)}");
			cstmt.setString(1, name);
			cstmt.setString(2, surname);
			cstmt.setString(3, email);
			cstmt.setString(4, password);
			cstmt.executeUpdate();
			System.out.println("Utente creato: " + email);

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch(SQLException e){
			if(e.getErrorCode()==20010)
			{//TODO: inserire pagina di errore pagina esistente
				System.out.println("ERRORE: Email already registered");
			}	
		}
	}


	public static void test_uknown_user_creation() throws IOException, ServletException
	{
		try {
			Connection conn = utils.connect_to_db();


			CallableStatement cstmt = conn.prepareCall("{? = call new_unknown_user()}");
			cstmt.registerOutParameter(1, Types.NUMERIC); //numero di output
			cstmt.executeUpdate();
			int user_id = cstmt.getInt(1);
			System.out.println("nuovo utente anonimo con id: " + user_id);
			//response.sendRedirect("http://localhost:8080/search_engine_java/html/login_success.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		
	}

	public static void test_search_query() throws ClassNotFoundException
	{
		LinkedList<String> url_results_list = new LinkedList<>();
		String search_keyword = "and";
		try {
			Connection conn = utils.connect_to_db();  
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
					" values (search_keyword, user_ref, term_ref);" +
					"    open l_rc for " +

					" select * from (select deref(nt.page).url  from table(select inverted_index from term_tab where term_name=search_keyword) nt order by nt.occurrences) "
					+ "where rownum <= 20;" +				
					"    ? := l_rc;" +
					" end if;" +
					" end;";

			CallableStatement cs;

			cs = conn.prepareCall(plsql);

			cs.setString(1, search_keyword);
			cs.setInt(2, 1);
			cs.registerOutParameter(3, OracleTypes.CURSOR);
			cs.execute();
			ResultSet cursorResultSet = (ResultSet) cs.getObject(3);
			String url;
			while (cursorResultSet.next ())
			{
				url = cursorResultSet.getString(1);
				if ( url != null)
					url_results_list.add(url);
			} 
			cs.close();
			System.out.print(url_results_list);

		} 
		catch (NullPointerException e)
		{
			System.out.println ("No results for keyword " + search_keyword);
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void test_show_page () throws ServletException, IOException
	{
		try {
			Connection conn = utils.connect_to_db();
			int user_id = 4010;
			String url = "www.prova.it";
			CallableStatement cstmt = conn.prepareCall("{? = call retrieve_text(?,?)}");
			cstmt.registerOutParameter(1, Types.VARCHAR); 
			cstmt.setInt(2, user_id);
			cstmt.setString(3, url);
			cstmt.executeUpdate();
			String text = cstmt.getString(1);
			System.out.println(text);
			//session.setAttribute("text_to_show", text);

			//TODO: prendere i links
			PreparedStatement pst = conn.prepareStatement("select deref(column_value).url  from table(select T.links from page_tab T where T.url = ?);");
			pst.setString(1, url);
			ResultSet res = pst.executeQuery();
			
			int isPresent = 0;
			String username = null;
			while(res.next()){
				username = res.getString(1);
				isPresent++;
			}
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		
	}
	
	public static void test_admin_stats() throws ServletException
	{
		try {
			Connection conn = utils.connect_to_db();
			//HttpSession session = request.getSession();			
	
			PreparedStatement pst = conn.prepareStatement("select * from(select user_id, searches_n from user_tab  order by searches_n desc ) where rownum <=10");
			ResultSet res = pst.executeQuery();
	
			LinkedList<Active_user> most_active_users =  new LinkedList<Active_user>();
			while(res.next()){
				most_active_users.add(new Active_user(res.getInt("user_id"), res.getInt("searches_n")));
			}
			System.out.println("Utenti più attivi: " + most_active_users);
			//session.setAttribute("most_active_users", most_active_users);
			for (Active_user user : most_active_users)
			{
				System.out.println("utente " + user.getUser_id());
			}
			
			//prendo le keyword cercate più di frequente
			PreparedStatement pst1 = conn.prepareStatement("select * from (select keyword, count (keyword) as total_key from search_tab group by keyword order by total_key desc) where rownum <= 10");
			ResultSet res1 = pst1.executeQuery();
	
			LinkedList<frequent_keyword> most_frequent_keywords =  new LinkedList<frequent_keyword>();
			while(res1.next()){
				most_frequent_keywords.add(new frequent_keyword(res1.getString("keyword"), res1.getInt("total_key")));
			}

			System.out.println("Parole più cercate: " + most_frequent_keywords);
			for (frequent_keyword key : most_frequent_keywords)
			{
				System.out.println("Parola " + key.getKeyword());
			}
			
			//response.sendRedirect("http://localhost:8080/search_engine_java/html/admin_stats_page.jsp");

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch(SQLException e){
			throw new ServletException(e);

		}		


	}


	public static void main(String[] args) throws ServletException, IOException, ClassNotFoundException {


		//login_test();
		//test_insert_new_page();
		//test_register_user();
		//login_test();
		//test_uknown_user_creation();
		//test_search_query();
		//test_show_page();
		test_admin_stats();
	}

}
