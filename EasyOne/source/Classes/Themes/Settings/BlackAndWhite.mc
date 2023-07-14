module Themes
{
    class BlackAndWhite extends ThemeSettingsBase
    {
        //Global
        var MainTextColor = 0xFFFFFF;
        var MainTextColor2 = 0xFFFFFF;

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
        var BatteryIndicatorBackgroundColor = 0xFFFFFF;
        var BatteryIndicatorFullColor = 0x3dd33a;
        var BatteryIndicatorHalfColor = 0xe1ef1a;
        var BatteryIndicatorLowColor = 0xee0520;

        //Icons Widget
        var IconsOff = 0xFFFFFF;
        var IconsOn = 0x3dd33a;

        //Indicatoren
        var IndicatorBackground = 0xFFFFFF;
        var IndicatorLevel1 = 0xFFFFFF; //Green
        var IndicatorLevel2 = 0xFFFFFF; //Green-Yellow
        var IndicatorLevel3 = 0xFFFFFF; //Yellow
        var IndicatorLevel4 = 0xFFFFFF; //Orange
        var IndicatorLevel5 = 0xFFFFFF; //Red

        //Distance Widget
        var DistanceStepsIconColor = 0xFFFFFF;
        var DistanceIconColor = 0xFFFFFF;
        var DistanceCaloriesColor = 0xFFFFFF;

        //DistanceWidget Indicator Colors
        var IndicatorSteps = [
            0xFFFFFF
        ];

        //Health Widget
        var HealthHeartIconColor = 0xFFFFFF;
        var HealthStressIconColor = 0xFFFFFF;
        var HealthBreathIconColor = 0xFFFFFF;
    }
}
