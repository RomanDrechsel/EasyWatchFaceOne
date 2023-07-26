module Themes
{
    class DarkBlue extends ThemeSettingsBase
    {
        var MainTextColor = 0x73b9e0;
        var MainTextColor2 = 0x73b9e0;

        //Background
        var BackgroundColor = 0x282a32;
        var BackgroundImage = null;

        //Clock Widget        
        var ClockHourColor = 0x73b9e0;
        var ClockMinutesColor = 0x0071a2;
        var ClockSecondsColor = 0xffffff;

        //Date Widget
        var DateWeekdayColor = 0xffffff;
        var DateDayColor = 0x0071a2;
        var DateYearColor = 0x73b9e0;

        function initialize()
        {
            if (Rez.Drawables has :BackgroundImageDark)
            {
                self.BackgroundImage = Rez.Drawables.BackgroundImageDark;
            }
            else
            {
                self.BackgroundImage = null;
            }
        }
    }
}
