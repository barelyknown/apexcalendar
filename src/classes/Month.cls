public class Month {
  
  public final Integer DEF_BUFFER_WEEKS = 2;
  public final Integer DAYS_PER_WEEK = 7;
  
	public Month(Integer monthNumber, Integer yearNumber) {
		this.monthNumber = monthNumber;
		this.yearNumber = yearNumber;
	}
	
	public Month(Date perspectiveDate) {
	  this.perspectiveDate = perspectiveDate;
	  this.monthNumber = perspectiveDate.month();
	  this.yearNumber = perspectiveDate.year();
	}
	
	public Integer yearNumber {
	  get; set;
	}
	
	public Integer monthNumber {
	  get; set;
	}
	
	public Date perspectiveDate {
	  get; set;
	}
	
	public String longName {
	  get {
	    return Datetime.newInstance(perspectiveDate,Time.newInstance(0,0,0,0)).format('MMMM');
	  }
	}
	
	public Integer daysInMonth {
	  get {
	    return Date.daysInMonth(yearNumber, monthNumber);
	  }
	}
	
	public Date startDate {
	  get {
	    return days.get(0).dateValue;
	  }
	}
	
	public Date endDate {
	  get {
	    return days.get(days.size() - 1).dateValue;
	  }
	}
	
	public Date startOfMonthDate {
	  get {
	    return Date.newInstance(yearNumber, monthNumber, 1);
	  }
	}
	
	public Date startOfNextMonthDate {
	  get {
	    return startOfMonthDate.addDays(daysInMonth);
	  }
	}
	
	public Integer bufferWeeks {
	  get {
	    if (bufferWeeks == null) {
	      return DEF_BUFFER_WEEKS;
	    }
	    return bufferWeeks;
	  }
	  set;
	}
	
	public Integer bufferDays {
	  get {
	    Date startOfMonth = Date.newInstance(yearNumber, monthNumber, 1);
	    Integer bufferDays = Math.abs(startOfMonth.daysBetween(startOfMonth.toStartOfWeek()));
	    bufferDays += bufferWeeks * DAYS_PER_WEEK;
	    return bufferDays;
	  }
	}
	
	public Integer bufferDaysAtEnd {
	  get {
	    Day endDay = new Day(startOfNextMonthDate.addDays(-1));
	    return 6 - endDay.weekDayNum;
	  }
	}
	
	public Day[] days {
	  get {
	    if (days == null) {
	      days = new Day[]{};
	      //ADD BUFFER DAYS AT FRONT OF MONTH
	      for (Integer bufferDay = bufferDays; bufferDay > 0; bufferDay--) {
	        Day day = new Day(startOfMonthDate.addDays(-bufferDay));
	        day.isSameMonth = false;
	        days.add(day);
	      }
	      //ADD THIS MONTHS DAYS
	      for (Integer i = 0; i < daysInMonth; i++) {
	        days.add(new Day(startOfMonthDate.addDays(i)));
	      }
	      //ADD BUFFER DAYS AT END OF MONTH
        for (Integer i = 0; i < bufferDaysAtEnd; i++) {
          Day day = new Day(startOfNextMonthDate.addDays(i));
          day.isSameMonth = false; 
          days.add(day);
        }
	    }
	    return days;
	  }
	  set;
	}
	
	// PUT THE DAYS INTO WEEKS
  public List<Day[]> weeks {
    get {
      weeks = new List<Day[]>();
      weeks.add(new Day[]{});
      for (Day day: days) {
        if (weeks.get(weeks.size() - 1).size() == DAYS_PER_WEEK) {
          weeks.add(new Day[]{});
        }
        weeks.get(weeks.size() - 1).add(day);
      }
      return weeks;
    }
    set;
  }
  
  
  public Integer[] weekdayNums {
    get {
      if (weekdayNums == null) {
        weekdayNums = new Integer[]{};
        for (Integer i = 0; i < DAYS_PER_WEEK; i++) {
          weekdayNums.add(i);
        }
      }
      return weekdayNums;
    }
    set;
  }
  
  public Map<Date, Day> dateMap {
    get {
      if (dateMap == null) {
        dateMap = new Map<Date, Day>();
        for (Day day: days) {
          dateMap.put(day.dateValue, day);
        }
      }
      return dateMap;
    }
    set;
  }
  
  public void addMeasureValueToDate(Date d, Decimal mv) {
    dateMap.get(d).measureValue = mv;
  }
	
}