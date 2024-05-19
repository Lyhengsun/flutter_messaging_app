String dateToTimeString(DateTime date, {bool onlyDate = false, bool fullDateTime = false}) {
  int days = date.day;
  int months = date.month;
  int years = date.year;
  int hours = (date.hour%12 == 0) ? 12 : date.hour%12;
  int minutes = date.minute;
  String meridiem = (date.hour >= 12) ? "PM" : "AM";

  // show all date 
  if (fullDateTime) {
    return "${intToMonthString(months)} $days $years AT $hours:$minutes $meridiem";
  }

  return "$hours:$minutes $meridiem";
}

String intToMonthString(int month) {
  switch (month) {
    case 1:
      return "JAN";
    case 2:
      return "FEB";
    case 3:
      return "MAR";
    case 4:
      return "APR";
    case 5:
      return "MAY";
    case 6:
      return "JUN";
    case 7:
      return "JUL";
    case 8:
      return "AUG";
    case 9:
      return "SEP";
    case 10:
      return "OCT";
    case 11:
      return "NOV";
    case 12:
      return "DEC";
    default:
      return "NONE";
  }
}