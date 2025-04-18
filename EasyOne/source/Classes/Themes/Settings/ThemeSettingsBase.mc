import Toybox.Lang;

module Themes {
    class ThemeSettingsBase {
        //Global
        var MainTextColor = 0x3dd33a;
        var MainTextColor2 = 0x3dd33a;

        //Background
        var BackgroundColor = 0;
        var BackgroundImage as Lang.ResourceId? = null;

        //Clock Widget
        var ClockHourColor = 0xffffff;
        var ClockMinutesColor = 0xffffff;
        var ClockSecondsColor = 0xffffff;

        //Date Widget
        var DateWeekdayColor = 0xffffff;
        var DateDayColor = 0xffffff;
        var DateYearColor = 0xffffff;

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
        var IndicatorLevel = [
            0x00ad15, //Green
            0xf7fa00, //Yellow
            0xfa7a00, //Orange
            0xfa0000, //Red
        ];

        //Distance Widget
        var DistanceStepsIconColor = 0xf7fa00;
        var DistanceIconColor = 0x0fcbc9;
        var DistanceCaloriesColor = 0xfa0000;

        //DistanceWidget Indicator Colors (from 100% to 0%)
        var IndicatorSteps = [0x00ad15, 0x85ca39, 0x78c84e, 0x6cc558, 0x61c361, 0x47bd8b, 0x2bb6b2, 0x2ba9b8, 0x379bb9, 0x4389be, 0x707fec, 0x6e75dd, 0x686fda, 0x6269d6, 0x5c63d4, 0x565ed1, 0x5058d0, 0x4b53cd, 0x454dcc, 0x3f47cb];

        //Health Widget
        var HealthHeartIconColor = 0xfa0000;
        var HealthStressIconColor = 0xf7fa00;
        var HealthBreathIconColor = 0x0fcbc9;
    }
}
