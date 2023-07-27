module Themes
{
    class Fire extends ThemeSettingsBase
    {
        function initialize()
        {
            if (Rez.Drawables has :BackgroundImageFire)
            {
                self.BackgroundImage = Rez.Drawables.BackgroundImageFire;
            }
            else
            {
                self.BackgroundImage = null;
            }

            self.MainTextColor = 0xFFFFFF;
            self.MainTextColor2 = 0xFFFFFF;

            //Background
            self.BackgroundColor = 0x590202;

            //Date Widget
            self.DateWeekdayColor = 0xC8FFFF;
            self.DateDayColor = 0x0690C2;
            self.DateYearColor = 0x49E3FF;

            //Clock Widget
            self.ClockHourColor = 0x49E3FF;
            self.ClockMinutesColor = 0x0690C2;
            self.ClockSecondsColor = 0xC8FFFF;
        }
    }
}
