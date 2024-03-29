import Toybox.Lang;

module Themes
{
    class ThemeSettingsBase
    {
        //Global
        var MainTextColor = 0x3dd33a;
        var MainTextColor2 = 0x3dd33a;

        //Background
        var BackgroundColor = 0;
        var BackgroundImage = null;

        //Clock Widget
        var ClockHourColor = 0xFFFFFF;
        var ClockMinutesColor = 0xFFFFFF;
        var ClockSecondsColor = 0xFFFFFF;

        //Date Widget
        var DateWeekdayColor = 0xFFFFFF;
        var DateDayColor = 0xFFFFFF;
        var DateYearColor = 0xFFFFFF;

        //Battery Widget
        var BatteryIndicatorBackgroundColor = 0x535353;
        var BatteryIndicatorFullColor = 0x3dd33a;
        var BatteryIndicatorHalfColor = 0xe1ef1a;
        var BatteryIndicatorLowColor = 0xee0520;

        //Icons Widget
        var IconsOff = 0x797979;
        var IconsOn = 0x3dd33a;

        //Indicatoren
        var IndicatorBackground = 0x535353;
        var IndivatorLevel = [
            0x00ad15, //Green
            0xf7fa00, //Yellow
            0xfa7a00, //Orange
            0xfa0000  //Red
        ];

        //Distance Widget
        var DistanceStepsIconColor = 0xf7fa00;
        var DistanceIconColor = 0x0fcbc9;
        var DistanceCaloriesColor = 0xfa0000;

        //DistanceWidget Indicator Colors
        var IndicatorSteps = [
            0x00ad15, /* 100% */
            0x75c846,
            0x2abcab,
            0x2a9fbc,
            0x2a7dbc,
            0x395dff,
            0x3f47cb /* 0% */
        ];

        //Health Widget
        var HealthHeartIconColor = 0xfa0000;
        var HealthStressIconColor = 0xf7fa00;
        var HealthBreathIconColor = 0x0fcbc9;
    }
}
