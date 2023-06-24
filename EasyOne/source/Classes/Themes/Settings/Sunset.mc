module Themes
{
    class Sunset extends ThemeSettingsBase
    {
        var MainTextColor = 0xBF5E49;
        var MainTextColor2 = 0xE1B27C;

        //Background
        var BackgroundImage = Rez.Drawables.BackgroundImageSunset;

        //Clock Widget
        var ClockHourColor = 0x0BCCE6;
        var ClockMinutesColor = 0x33BFDE;
        var ClockSecondsColor = 0x0DE4FF;

        //Date Widget
        var DateWeekdayColor = 0x0DE4FF;
        var DateDayColor = 0x33BFDE;
        var DateYearColor = 0x0BCCE6;

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
    }
}
