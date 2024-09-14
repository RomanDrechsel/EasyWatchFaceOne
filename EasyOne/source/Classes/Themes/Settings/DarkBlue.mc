module Themes {
    class DarkBlue extends ThemeSettingsBase {
        function initialize() {
            if (Rez.Drawables has :BackgroundImageDark) {
                self.BackgroundImage = Rez.Drawables.BackgroundImageDark;
            } else {
                self.BackgroundImage = null;
            }

            self.MainTextColor = 0x73b9e0;
            self.MainTextColor2 = 0x73b9e0;

            //Background
            self.BackgroundColor = 0x282a32;

            //Clock Widget
            self.ClockHourColor = 0x73b9e0;
            self.ClockMinutesColor = 0x0071a2;
            self.ClockSecondsColor = 0xffffff;

            //Date Widget
            self.DateWeekdayColor = 0xffffff;
            self.DateDayColor = 0x0071a2;
            self.DateYearColor = 0x73b9e0;
        }
    }
}
