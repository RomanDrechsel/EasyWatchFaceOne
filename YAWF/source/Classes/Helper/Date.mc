import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian as Date;

module Helper 
{
    class Date
    {
        static var ShortWeekdays = {} as Dictionary<Number, String>;
        static var ShortMonths = {} as Dictionary<Number, String>;

        //loads strings from resources
        static function loadResource()
        {
            
        }

        //short version of day of week
        static function ShortWeekyday(greg_dayofweek as Number) as String
        {
            var dayofweek = 1 + (greg_dayofweek + 5) % 7; //fix first-day-of-week settings...

            if (self.ShortWeekdays.hasKey(dayofweek) == false)
            {
                self.ShortWeekdays[dayofweek] = self.LoadShortWeekday(dayofweek);
            }
            return self.ShortWeekdays[dayofweek];
        }

        //short month name
        static function ShortMonth(month as Number) as String
        {
            if (self.ShortMonths.hasKey(month) == false)
            {
                self.ShortMonths[month] = self.LoadShortMonth(month);
            }
            return self.ShortMonths[month];
        }

        //get short day of week from resources
        private static function LoadShortWeekday(day as Number) as String
        {
            switch (day)
            {
                case 1: return Ui.loadResource(Rez.Strings.ShortMonday);
                case 2: return Ui.loadResource(Rez.Strings.ShortTuesday);
                case 3: return Ui.loadResource(Rez.Strings.ShortWednesday);
                case 4: return Ui.loadResource(Rez.Strings.ShortThursday);
                case 5: return Ui.loadResource(Rez.Strings.ShortFriday);
                case 6: return Ui.loadResource(Rez.Strings.ShortSaturday);
                case 7: return Ui.loadResource(Rez.Strings.ShortSunday);
            }
            return "";
        }

        //get short month from resources
        private static function LoadShortMonth(month as Number) as String
        {
            switch (month)
            {
                case 1: return Ui.loadResource(Rez.Strings.ShortJanuar);
                case 2: return Ui.loadResource(Rez.Strings.ShortFebruary);
                case 3: return Ui.loadResource(Rez.Strings.ShortMarch);
                case 4: return Ui.loadResource(Rez.Strings.ShortApril);
                case 5: return Ui.loadResource(Rez.Strings.ShortMay);
                case 6: return Ui.loadResource(Rez.Strings.ShortJune);
                case 7: return Ui.loadResource(Rez.Strings.ShortJuly);
                case 8: return Ui.loadResource(Rez.Strings.ShortAugust);
                case 9: return Ui.loadResource(Rez.Strings.ShortSeptember);
                case 10: return Ui.loadResource(Rez.Strings.ShortOctober);
                case 11: return Ui.loadResource(Rez.Strings.ShortNovember);
                case 12: return Ui.loadResource(Rez.Strings.ShortDecember);
            }

            return month.toString();
        }
    }
}