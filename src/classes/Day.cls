public class Day {
  
  public static Map<Integer,String> shortDayNameMap {
    get {
      if (shortDayNameMap == null) {
        shortDayNameMap = new Map<Integer, String>();
      }
      for (Integer i = 0; i < 7; i++) {
        shortDayNameMap.put(i,Datetime.newInstance(System.today().toStartOfWeek().addDays(i),Time.newInstance(0,0,0,0)).format('EEE'));
      }
      return shortDayNameMap;
    }
    set;
  }
  
	public Day(Date dateValue) {
		this.dateValue = dateValue;
	}
	
	public Date dateValue {
	  get;
	  set;
	}
	
	public Decimal measureValue {
	  get; set;
	}
	
	public Integer num {
	  get {
	    return dateValue.day();
	  }
	}
	
	public Integer weekDayNum {
	  get {
	    return Math.abs(dateValue.daysBetween(dateValue.toStartOfWeek()));
	  }
	}
	
	public String shortName {
	  get {
	    return Datetime.newInstance(dateValue,Time.newInstance(0,0,0,0)).format('EEE');
	  }
	}
	
	public Boolean isSameMonth {
	  get {
	    if (isSameMonth == null) {
	      return true;
	    }
	    return isSameMonth;
	  }
	  set;
	}
	
}