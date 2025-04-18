module Themes {
    class Fire extends ThemeSettingsBase {
        function initialize() {
            ThemeSettingsBase.initialize();
            if (Rez.Drawables has :BackgroundImageFire) {
                self.BackgroundImage = Rez.Drawables.BackgroundImageFire;
            } else {
                self.BackgroundImage = null;
            }

            self.MainTextColor = 0xffffff;
            self.MainTextColor2 = 0xffffff;

            //Background
            self.BackgroundColor = 0x590202;

            //Date Widget
            self.DateWeekdayColor = 0xc8ffff;
            self.DateDayColor = 0x0690c2;
            self.DateYearColor = 0x49e3ff;

            //Clock Widget
            self.ClockHourColor = 0x49e3ff;
            self.ClockMinutesColor = 0x0690c2;
            self.ClockSecondsColor = 0xc8ffff;
        }
    }
}
