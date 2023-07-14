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
        var BackgroundImage = -1;

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
        var IndicatorLevel1 = 0x00ad15; //Green
        var IndicatorLevel2 = 0xc4ff31; //Green-Yellow
        var IndicatorLevel3 = 0xf7fa00; //Yellow
        var IndicatorLevel4 = 0xfa7a00; //Orange
        var IndicatorLevel5 = 0xfa0000; //Red

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
            0x2a45bc,
            0x3f47cb /* 0% */
        ];

        //Health Widget
        var HealthHeartIconColor = 0xfa0000;
        var HealthStressIconColor = 0xf7fa00;
        var HealthBreathIconColor = 0x0fcbc9;
    }
}
