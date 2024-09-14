module Themes {
    class BSoD extends ThemeSettingsBase {
        function initialize() {
            self.MainTextColor = 0xffffff;
            self.MainTextColor2 = 0xffffff;

            //Background
            self.BackgroundColor = 0x0827f5;

            //Clock Widget
            self.ClockHourColor = 0xffffff;
            self.ClockMinutesColor = 0xffffff;
            self.ClockSecondsColor = 0xffffff;

            //Date Widget
            self.DateWeekdayColor = 0xffffff;
            self.DateDayColor = 0xffffff;
            self.DateYearColor = 0xffffff;

            //Battery Widget
            self.BatteryIndicatorBackgroundColor = 0xaaaaaa;

            //Icons Widget
            self.IconsOff = 0xaaaaaa;

            //Indicatoren
            self.IndicatorBackground = 0xaaaaaa;

            //Distance Widget
            self.DistanceStepsIconColor = 0xffffff;
            self.DistanceIconColor = 0xffffff;
            self.DistanceCaloriesColor = 0xffffff;

            //Health Widget
            self.HealthHeartIconColor = 0xffffff;
            self.HealthStressIconColor = 0xffffff;
            self.HealthBreathIconColor = 0xffffff;
        }
    }
}
