public class MonthDetail {
	public MonthDetail() {
		
	}
	
	public final Integer DEF_ROW_HEIGHT = 50;
	

  public Month altMonth {
    get; set;
  }

	public Month month {
	  get {
	    if (altMonth != null) {
	      return altMonth;
	    } else {
	      month = new Month(monthNumber, yearNumber);
	    }
	    return month;
	  }
	  set;
	}
	
	public Integer altMonthNumber {
	  get; set;
	}
	
	public Integer monthNumber {
	  get {
	    if (altMonthNumber != null) {
	      return altMonthNumber;
	    }
	    return monthNumber;
	  }
	  set;
	}
	
	public Integer altYearNumber {
	  get; set;
	}
	
	public Integer yearNumber {
	  get {
	    if (altYearNumber != null) {
	      return altYearNumber;
	    }
	    return yearNumber;
	  }
	  set;
	}
	
	public String altTitle {
    get; set;
	}
	
	public String title {
	  get {
	    if (altTitle != null) {
	      return altTitle;
	    }
	    return title;
	  }
	}
	
	public Integer altRowHeight {
	  get; set;
	}
	
	public Integer rowHeight {
	  get {
	    return DEF_ROW_HEIGHT;
	  }
	  set;
	}
	
	public Map<Integer, String> shortDayNameMap {
	  get {
	    return Day.shortDayNameMap;
	  }
	}
}