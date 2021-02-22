package models;

public class Active_user {
	private int user_id;
	private int n_searches;
	
	public Active_user(int id, int searches) {
		this.setN_searches(searches);
		this.setUser_id(id);
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public int getN_searches() {
		return n_searches;
	}

	public void setN_searches(int n_searches) {
		this.n_searches = n_searches;
	}
	
	

}
