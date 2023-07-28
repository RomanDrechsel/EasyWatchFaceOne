module Themes
{
    class BlackAndWhite extends ThemeSettingsBase
    {
        function initialize()
        {
            //Global
            self.MainTextColor = 0xFFFFFF;
            self.MainTextColor2 = 0xFFFFFF;

            //Background
            self.BackgroundColor = 0;

            //Clock Widget
            self.ClockHourColor = 0xFFFFFF;
            self.ClockMinutesColor = 0xFFFFFF;
            self.ClockSecondsColor = 0xFFFFFF;

            //Date Widget
            self.DateWeekdayColor = 0xFFFFFF;
            self.DateDayColor = 0xFFFFFF;
            self.DateYearColor = 0xFFFFFF;

            //Battery Widget
            self.BatteryIndicatorBackgroundColor = 0xFFFFFF;
            self.BatteryIndicatorFullColor = 0x3dd33a;
            self.BatteryIndicatorHalfColor = 0xe1ef1a;
            self.BatteryIndicatorLowColor = 0xee0520;

            //Icons Widget
            self.IconsOff = 0xFFFFFF;
            self.IconsOn = 0x3dd33a;

            //Indicatoren
            self.IndicatorBackground = 0xFFFFFF;
            self.IndicatorLevel1 = 0xFFFFFF; //Green
            self.IndicatorLevel2 = 0xFFFFFF; //Green-Yellow
            self.IndicatorLevel3 = 0xFFFFFF; //Yellow
            self.IndicatorLevel4 = 0xFFFFFF; //Orange
            self.IndicatorLevel5 = 0xFFFFFF; //Red

            //Distance Widget
            self.DistanceStepsIconColor = 0xFFFFFF;
            self.DistanceIconColor = 0xFFFFFF;
            self.DistanceCaloriesColor = 0xFFFFFF;

            //DistanceWidget Indicator Colors
            self.IndicatorSteps = [
                0xFFFFFF
            ];

            //Health Widget
            self.HealthHeartIconColor = 0xFFFFFF;
            self.HealthStressIconColor = 0xFFFFFF;
            self.HealthBreathIconColor = 0xFFFFFF;
        }
    }
}
