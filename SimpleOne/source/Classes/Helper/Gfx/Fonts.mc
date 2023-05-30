import Toybox.WatchUi;

module Helper
{ 
    module Gfx
    {
        class Fonts
        {
            static var Clock = null as FontResource;
            static var ClockSmall = null as FontResource;
            static var Date = null as FontResource;
            static var Normal = null as FontResource;
            static var Small = null as FontResource;
            static var Tiny = null as FontResource;
            static var Icons = null as FontResource;

            static function Load()
            {
                self.Clock = WatchUi.loadResource(Rez.Fonts.ClockFont);
                self.ClockSmall = WatchUi.loadResource(Rez.Fonts.ClockFontSmall);
                self.Date = WatchUi.loadResource(Rez.Fonts.DateFont);
                self.Normal = WatchUi.loadResource(Rez.Fonts.Normal);
                self.Small = WatchUi.loadResource(Rez.Fonts.Small);
                self.Tiny = WatchUi.loadResource(Rez.Fonts.Tiny);
                self.Icons = WatchUi.loadResource(Rez.Fonts.Icons);
            }
        }
    }
}