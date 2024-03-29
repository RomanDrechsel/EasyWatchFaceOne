import Toybox.Lang;
import Toybox.Application;

module Themes
{
    class Colors
    {
        static var Text = 0xffffff;
        static var Text2 = 0xffffff;
        static var DateWeekday = 0xffffff;
        static var DateDay = 0xffffff;
        static var DateYear = 0xffffff;
        static var TimeHour = 0xffffff;
        static var TimeMinute = 0xffffff;
        static var TimeSecond = 0xffffff;
        static var TimeAMPM = 0xffffff;
        static var IconsInTextColor = false;

        private static var fallbackColor = 0xFFFFFF;

        static function ResetColors()
        {
            var customcolors = Application.Properties.getValue("CC") as Number;
            if (customcolors == 1)
            {
                self.Text = self.GetColorFromProperties("CT");
                self.Text2 = self.Text;
                self.DateWeekday = self.GetColorFromProperties("CWeek");
                self.DateDay = self.GetColorFromProperties("CDay");
                self.DateYear = self.GetColorFromProperties("CYear");
                self.TimeHour = self.GetColorFromProperties("CHour");
                self.TimeMinute = self.GetColorFromProperties("CMin");
                self.TimeSecond = self.GetColorFromProperties("CSec");
                self.TimeAMPM = self.GetColorFromProperties("CMAP");
                var icons = Application.Properties.getValue("IconC") as Number;
                if (icons == 1)
                {
                    self.IconsInTextColor = true;
                }
                else
                {
                    self.IconsInTextColor = false;
                }
            }
            else
            {
                var theme = $.getTheme();
                self.Text = theme.MainTextColor;
                self.Text2 = theme.MainTextColor2;
                self.DateWeekday = theme.DateWeekdayColor;
                self.DateDay = theme.DateDayColor;
                self.DateYear = theme.DateYearColor;
                self.TimeHour = theme.ClockHourColor;
                self.TimeMinute = theme.ClockMinutesColor;
                self.TimeSecond = theme.ClockSecondsColor;
                self.TimeAMPM = theme.ClockSecondsColor;
                self.IconsInTextColor = false;
            }
        }

        private static function GetColorFromProperties(key as String) as Number
        {
            //custom color
            var customcolor = Application.Properties.getValue(key) as String;
            var color = Helper.String.stringReplace(customcolor, "#", "").toNumberWithBase(16);

            if (color == null)
            {
                color = self.fallbackColor;
            }

            return color;
        }
    }
}
