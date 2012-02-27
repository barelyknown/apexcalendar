Introduction
============
This is a set of classes and a component that make it easy to render a calendar view of a dataset in Visualforce on the Force.com platform.

Simple Example
--------------
If you just need a calendar, you can use the calendar component in any page to get a calendar view of any calendar.

`<c:month altMonthNumber="9" altYearNumber="1977" />`

![Example 1](apexcalendar/blob/master/img/apexcalendar_example_1.png "Example 1")

If you want to highlight a particular date, pass in the day number also.

`<c:month altMonthNumber="9" altYearNumber="1977" altDayNumber="9" />`

![Example 2](apexcalendar/blob/master/img/apexcalendar_example_2.png "Example 2")

Adding Data
-----------
If you want to add data to the calendar, use the Month class and the `addMeasureValueToDate(Date d, Decimal mv)` method and pass the instance of the Month class that you create to the component.

Here's an example controller that will add a measure to each date that shows how many days old I was on each day on or after my birthdate.

<pre>
  public Month birthMonth {
    get {
      Date birthday = Date.newInstance(1977,12,9);
      birthmonth = new Month(birthday);
      for (Day d: birthmonth.days) {
        if (d.dateValue >= birthday) {
          birthMonth.addMeasureValueToDate(d.dateValue, birthday.daysBetween(d.dateValue));          
        }
      }
      return birthMonth;
    }
    set;
  }
</pre>

Now I can pass the birthMonth property into my component and it will show my age in days for each date on the calendar view.

`<c:month altMonth="{!birthMonth}" />`

![Example 3](apexcalendar/blob/master/img/apexcalendar_example_3.png "Example 3")

Adding Weeks
------------
Sometimes it helps to show a few weeks before the start of the month to put the current month in perspective. If you change the `bufferWeeks` property on your Month instance, it will add that number of weeks before the first partial week in your month view.

Let's pretend that I added the following line to the controller example above after creating the `birthMonth`:

`birthmonth.bufferWeeks = 2;`

Here's what the calendar would look like with the buffer weeks added:

![Example 4](apexcalendar/blob/master/img/apexcalendar_example_4.png "Example 4")

Just the Start
--------------
Many other things are possible that haven't been implemented yet. For example, you could highlight dates based on their rank, or you could add other types of "measure values" to each date (besides Integers) and have them display properly. You could also print multiple months in a few. But, this is a nice start and I figured that I'd share it so that others could contribute too.
