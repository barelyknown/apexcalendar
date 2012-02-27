public class ApexCalendarExample {

  public Month thisMonth {
    get {
      thisMonth = new Month(System.today());
      thisMonth.addMeasureValueToDate(System.today().addDays(-1),45);
      return thisMonth;
    }
    set;
  }
  
  public Month birthMonth {
    get {
      Date birthday = Date.newInstance(1977,12,9);
      birthmonth = new Month(birthday);
      birthMonth.bufferWeeks = 2;
      for (Day d: birthmonth.days) {
        if (d.dateValue >= birthday) {
          birthMonth.addMeasureValueToDate(d.dateValue, birthday.daysBetween(d.dateValue));          
        }
      }
      return birthMonth;
    }
    set;
  }
  
}
