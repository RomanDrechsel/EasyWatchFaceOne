import Toybox.Lang;

module Themes
{
    class ThemeSettingsBase
    {
        //Background
        var BackgroundColor = 0 as Number;
        var BackgroundImage = -1 as Number;

        //Clock Widget
        var ClockMainColor = 0xFFFFFF as Number;
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
    }
}
