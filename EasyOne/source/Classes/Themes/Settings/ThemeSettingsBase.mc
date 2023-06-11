import Toybox.Lang;

module Themes
{
    class ThemeSettingsBase
    {
        //Global
        var MainTextColor = 0x3dd33a;

        //Background
        var BackgroundColor = 0 as Number;
        var BackgroundImage = -1 as Number;

        //Clock Widget
        var ClockHourColor = 0xFFFFFF as Number;
        var ClockMinutesColor = 0xFFFFFF as Number;
        var ClockSecondsColor = 0xFFFFFF as Number;

        //Date Widget
        var DateWeekdayColor = 0xFFFFFF as Number;
        var DateDayColor = 0xFFFFFF as Number;
        var DateYearColor = 0xFFFFFF as Number;

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
        var DistanceStepsIconColor = 0x3dd33a;
        var DistanceIconColor = 0x3dd33a;
        var DistanceCaloriesColor = 0x3dd33a;

        //DistanceWidget Indicator Colors
        var IndicatorSteps = [
            0x00ad15, /* 100% */
            0x75c846,
            0x2abcab,
            0x2a9fbc,
            0x2a7dbc,
            0x2a45bc,
            0x171f9c /* 0% */
        ];

        //Health Widget
        var HealthHeartIconColor = 0x3dd33a;
        var HealthStressIconColor = 0x3dd33a;
        var HealthBreathIconColor = 0x3dd33a;

    }
}
