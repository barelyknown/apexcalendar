public class Month {
  
  public final Integer DEF_BUFFER_WEEKS = 0;
  public final Integer DAYS_PER_WEEK = 7;
  
	public Month(Integer yearNumber, Integer monthNumber, Integer dayNumber) {
		this.yearNumber = yearNumber;
		this.monthNumber = monthNumber;
		this.dayNumber = dayNumber;
	}
	
	public Month(Date perspectiveDate) {
	  this.perspectiveDate = perspectiveDate;
	  this.yearNumber = perspectiveDate.year();
	  this.monthNumber = perspectiveDate.month();
	  this.dayNumber = perspectiveDate.day();
	}
	
	public Integer yearNumber {
	  get; set;
	}
	
	public Integer monthNumber {
	  get; set;
	}
	
	public Integer dayNumber {
	  get; set;
	}
	
	public Date perspectiveDate {
	  get; set;
	}
	
	public String longName {
	  get {
	    return Datetime.newInstance(Date.newInstance(yearNumber, monthNumber,1),Time.newInstance(0,0,0,0)).format('MMMM');
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
	    Integer bufferDays = Math.abs(startOfMonthDate.daysBetween(startOfMonthDate.toStartOfWeek()));
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
	
	static testMethod void createFromNumbers() {
	  Integer year = 2012;
	  Integer month = 1;
	  Integer day = 1;
	  Month m = new Month(year,month,year);
	  System.assert(m.yearNumber == year, 'The year was ' + m.yearNumber + ' not ' + year + '.');
	  System.assert(m.monthNumber == month, 'The month was ' + m.monthNumber + ' not ' + month + '.');
	  System.assert(m.dayNumber == year, 'The day was ' + m.dayNumber + ' not ' + day + '.');
	}
	
	static testMethod void createFromDate() {
	  Date birthDate = Date.newInstance(1977,12,9);
	  Month m = new Month(birthdate);
	  System.assert(m.yearNumber == birthdate.year(), 'The year was ' + m.yearNumber + ' not ' + birthdate.year() + '.');
	  System.assert(m.monthNumber == birthdate.month(), 'The month was ' + m.monthNumber + ' not ' + birthdate.month() + '.');
	  System.assert(m.dayNumber == birthdate.day(), 'The day was ' + m.dayNumber + ' not ' + birthdate.day() + '.');
	  System.assert(m.longName == 'December','The longname was ' + m.longName + ' not ' + 'December.');
	  System.assert(m.daysInMonth == Date.daysInMonth(m.yearNumber, m.monthNumber), 'The daysInMonth are not being calculated properly.');
	  System.assert(m.startOfMonthDate == Date.newInstance(m.yearNumber, m.monthNumber, 1), 'The startOfMonthDate is not being set properly.');
	  System.assert(m.startOfNextMonthDate == m.startOfMonthDate.addDays(m.daysInMonth),'The startOfNextMonthDate is not being calculated properly.');
	  System.assert(m.bufferWeeks == m.DEF_BUFFER_WEEKS, 'The default bufferWeeks is not being returned by, er, default.');
	  Integer birthMonthBaseBufferDays = 4;
    System.assert(m.bufferDays == birthMonthBaseBufferDays + (m.DAYS_PER_WEEK * m.bufferWeeks),'The default buffer week case is not translating into an accurate number of buffer days.');
	  Integer newBufferWeeks = 2;
    m.bufferWeeks = newBufferWeeks;
    System.assert(m.bufferWeeks == newBufferWeeks, 'The new bufferWeeks are not being set correctly.');
    Integer birthMonthBaseEndBufferDays = 0;
    System.assert(m.bufferDaysAtEnd == birthMonthBaseEndBufferDays,'The bufferDaysAtEnd is not being set correctly.');
    Integer expectedDays = m.bufferDays + m.daysInMonth + m.bufferDaysAtEnd;
    System.assert(m.days.size() == m.bufferDays + m.daysInMonth + m.bufferDaysAtEnd, 'The number of days was ' + m.days.size() + ' instead of ' + expectedDays);
    for (Day d: m.days) {
      if (d.dateValue.month() != m.monthNumber || d.dateValue.year() != m.yearNumber) {
        System.assert(d.isSameMonth == false, 'A day ' + d.dateValue.format() + ' in a different months are being marked as the same month.');
      } else {
        System.assert(d.isSameMonth == true, 'A day ' + d.dateValue.format() + ' in the same month is being markes as a different month.');
      }
    }
    Month monthWithEndBufferDays = new Month(1978,1,1);
    Integer shouldStartBufferDays = 0;
    Integer shouldEndBufferDays = 4;
    expectedDays = shouldStartBufferDays + monthWithEndBufferDays.daysInMonth + shouldEndBufferDays;
    System.assert(monthWithEndBufferDays.days.size() == expectedDays, 'The number of days was ' + monthWithEndBufferDays.days.size() + ' instead of ' + expectedDays);
    System.assert(monthWithEndBufferDays.startDate == monthWithEndBufferDays.days.get(0).dateValue, 'The first date of the month is incorrect.');
    System.assert(monthWithEndBufferDays.endDate == monthWithEndBufferDays.days.get(monthWithEndBufferDays.days.size() - 1).dateValue, 'The last date of the month is incorrect.');
    
    System.assert(monthWithEndBufferDays.weeks.size() == monthWithEndBufferDays.days.size() / 7, 'There the the wrong number of weeks. ' + String.valueof(monthWithEndBufferDays.weeks.size()) + ' instead of ' + String.valueof(monthWithEndBufferDays.daysInMonth / 7));
    for (Integer i = 0; i < monthWithEndBufferDays.weekDayNums.size(); i++) {
      System.assert(monthWithEndBufferDays.weekDayNums.get(i) == i, 'The week day wasnt right or wasnt in order.');
    }
    for (Day d: monthWithEndBufferDays.days) {
      System.assert(monthWithEndBufferDays.dateMap.get(d.dateValue) == d, 'The date map is wrong. ');
    }
    for (Integer i = 0; i < monthWithEndBufferDays.days.size(); i++) {
      monthWithEndBufferDays.addMeasureValueToDate(monthWithEndBufferDays.days.get(i).dateValue, monthWithEndBufferDays.days.get(i).dateValue.month() + monthWithEndBufferDays.days.get(i).dateValue.day());
    }
    for (Day d: monthWithEndBufferDays.days) {
      System.assert(d.measureValue == d.dateValue.month() + d.dateValue.day(), 'The measure value was set incorrectly.');
    }
	}
	
	
	
}