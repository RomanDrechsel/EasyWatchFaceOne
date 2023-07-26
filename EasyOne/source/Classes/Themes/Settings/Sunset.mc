module Themes
{
    class Sunset extends ThemeSettingsBase
    {
        var MainTextColor = 0xd77d00;
        var MainTextColor2 = 0xeb9633;

        //Background
        var BackgroundColor = 0xFAD6A5;
        var BackgroundImage = null;

        //Clock Widget
        var ClockHourColor = 0x56def0;
        var ClockMinutesColor = 0x3ebcd7;
        var ClockSecondsColor = 0x0DE4FF;

        //Date Widget
        var DateWeekdayColor = 0x09b0c7;
        var DateDayColor = 0x13c1d9;
        var DateYearColor = 0x09b0c7;

        //Battery Widget
        var BatteryIndicatorFullColor = 0x12960f;

        //Icons Widget
        var IconsOff = 0x535353;
        var IconsOn = 0x12960f;

        //Distance Widget
        var DistanceStepsIconColor = 0x00ad15;
        var DistanceIconColor = 0x0fcbc9;
        var DistanceCaloriesColor = 0xfa0000;

        //Health Widget
        var HealthHeartIconColor = 0xfa0000;
        var HealthStressIconColor = 0xe9731f;
        var HealthBreathIconColor = 0xfff500;

        function initialize()
        {
            if (Rez.Drawables has :BackgroundImageSunset)
            {
                self.BackgroundImage = Rez.Drawables.BackgroundImageSunset;
            }
            else
            {
                self.BackgroundImage = null;
            }
        }
    }
}
