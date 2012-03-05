public class ApexCalendar_Example {
  
  public ApexCalendar_Month birthMonth {
    get {
      Date birthday = Date.newInstance(1977,12,9);
      birthmonth = new ApexCalendar_Month(birthday);
      birthMonth.bufferWeeks = 2;
      for (ApexCalendar_Day d: birthmonth.days) {
        if (d.dateValue >= birthday) {
          birthMonth.addMeasureValueToDate(d.dateValue, birthday.daysBetween(d.dateValue));          
        }
      }
      return birthMonth;
    }
    set;
  }
  
}