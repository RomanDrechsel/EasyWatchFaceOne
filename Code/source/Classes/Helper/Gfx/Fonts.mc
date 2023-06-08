import Toybox.WatchUi;

module Helper
{ 
    module Gfx
    {
        class Fonts
        {
            static var Hour = null as FontResource;
            static var Minute = null as FontResource;
            static var Seconds = null as FontResource;
            static var Date = null as FontResource;
            static var Normal = null as FontResource;
            static var Small = null as FontResource;
            static var Tiny = null as FontResource;
            static var Icons = null as FontResource;

            static function Load()
            {
                self.Hour = WatchUi.loadResource(Rez.Fonts.HourFont);
                self.Minute = WatchUi.loadResource(Rez.Fonts.MinuteFont);
                self.Seconds = WatchUi.loadResource(Rez.Fonts.SecondsFont);
                self.Date = WatchUi.loadResource(Rez.Fonts.DateFont);
                self.Normal = WatchUi.loadResource(Rez.Fonts.Normal);
                self.Small = WatchUi.loadResource(Rez.Fonts.Small);
                self.Tiny = WatchUi.loadResource(Rez.Fonts.Tiny);
                self.Icons = WatchUi.loadResource(Rez.Fonts.Icons);
            }
        }
    }
}