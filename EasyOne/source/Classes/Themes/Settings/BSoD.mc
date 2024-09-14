module Themes
{
    class BSoD extends ThemeSettingsBase
    {
        function initialize()
        {
            self.MainTextColor = 0xFFFFFF;
            self.MainTextColor2 = 0xFFFFFF;

            //Background
            self.BackgroundColor = 0x0827F5;

            //Clock Widget        
            self.ClockHourColor = 0xFFFFFF;
            self.ClockMinutesColor = 0xFFFFFF;
            self.ClockSecondsColor = 0xFFFFFF;

            //Date Widget
            self.DateWeekdayColor = 0xFFFFFF;
            self.DateDayColor = 0xFFFFFF;
            self.DateYearColor = 0xFFFFFF;

            //Battery Widget
            self.BatteryIndicatorBackgroundColor = 0xAAAAAA;

            //Icons Widget
            self.IconsOff = 0xAAAAAA;

            //Indicatoren
            self.IndicatorBackground = 0xAAAAAA;

            //Distance Widget
            self.DistanceStepsIconColor = 0xFFFFFF;
            self.DistanceIconColor = 0xFFFFFF;
            self.DistanceCaloriesColor = 0xFFFFFF;

            //Health Widget
            self.HealthHeartIconColor = 0xFFFFFF;
            self.HealthStressIconColor = 0xFFFFFF;
            self.HealthBreathIconColor = 0xFFFFFF;
        }
    }
}
