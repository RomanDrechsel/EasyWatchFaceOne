module Themes {
    class BlackAndWhite extends ThemeSettingsBase {
        function initialize() {
            ThemeSettingsBase.initialize();

            //Global
            self.MainTextColor = 0xffffff;
            self.MainTextColor2 = 0xffffff;

            //Background
            self.BackgroundColor = 0;

            //Clock Widget
            self.ClockHourColor = 0xffffff;
            self.ClockMinutesColor = 0xffffff;
            self.ClockSecondsColor = 0xffffff;

            //Date Widget
            self.DateWeekdayColor = 0xffffff;
            self.DateDayColor = 0xffffff;
            self.DateYearColor = 0xffffff;

            //Battery Widget
            self.BatteryIndicatorBackgroundColor = 0xffffff;
            self.BatteryIndicatorFullColor = 0x3dd33a;
            self.BatteryIndicatorHalfColor = 0xe1ef1a;
            self.BatteryIndicatorLowColor = 0xee0520;

            //Icons Widget
            self.IconsOff = 0xffffff;
            self.IconsOn = 0x3dd33a;

            //Indicatoren
            self.IndicatorBackground = 0xffffff;
            self.IndicatorLevel = [0xffffff, 0xffffff, 0xffffff, 0xffffff];

            //Distance Widget
            self.DistanceStepsIconColor = 0xffffff;
            self.DistanceIconColor = 0xffffff;
            self.DistanceCaloriesColor = 0xffffff;

            //DistanceWidget Indicator Colors
            self.IndicatorSteps = [0xffffff];

            //Health Widget
            self.HealthHeartIconColor = 0xffffff;
            self.HealthStressIconColor = 0xffffff;
            self.HealthBreathIconColor = 0xffffff;
        }
    }
}
