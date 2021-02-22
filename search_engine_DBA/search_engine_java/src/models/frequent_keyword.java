package models;

public class frequent_keyword {
	private String keyword;
	private int frequency;

	public frequent_keyword(String keyword, int frequency) {
		this.frequency=frequency;
		this.keyword=keyword;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

}
