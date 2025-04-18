module Themes {
    class Sunset extends ThemeSettingsBase {
        function initialize() {
            ThemeSettingsBase.initialize();
            if (Rez.Drawables has :BackgroundImageSunset) {
                self.BackgroundImage = Rez.Drawables.BackgroundImageSunset;
            } else {
                self.BackgroundImage = null;
            }

            self.MainTextColor = 0xd77d00;
            self.MainTextColor2 = 0xeb9633;

            //Background
            self.BackgroundColor = 0x181c41;

            //Clock Widget
            self.ClockHourColor = 0x56def0;
            self.ClockMinutesColor = 0x3ebcd7;
            self.ClockSecondsColor = 0x0de4ff;

            //Date Widget
            self.DateWeekdayColor = 0x09b0c7;
            self.DateDayColor = 0x13c1d9;
            self.DateYearColor = 0x09b0c7;

            //Battery Widget
            self.BatteryIndicatorFullColor = 0x12960f;

            //Icons Widget
            self.IconsOff = 0x535353;
            self.IconsOn = 0x12960f;

            //Distance Widget
            self.DistanceStepsIconColor = 0x00ad15;
            self.DistanceIconColor = 0x0fcbc9;
            self.DistanceCaloriesColor = 0xfa0000;

            //Health Widget
            self.HealthHeartIconColor = 0xfa0000;
            self.HealthStressIconColor = 0xe9731f;
            self.HealthBreathIconColor = 0xfff500;
        }
    }
}
