module Themes
{
    class Fire extends ThemeSettingsBase
    {
        var MainTextColor = 0xFFFFFF;
        var MainTextColor2 = 0xFFFFFF;

        //Background
        var BackgroundColor = 0x590202;
        var BackgroundImage = null;

        //Date Widget
        var DateWeekdayColor = 0xC8FFFF;
        var DateDayColor = 0x0690C2;
        var DateYearColor = 0x49E3FF;

        //Clock Widget
        var ClockHourColor = 0x49E3FF;
        var ClockMinutesColor = 0x0690C2;
        var ClockSecondsColor = 0xC8FFFF;

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
        }
    }
}
