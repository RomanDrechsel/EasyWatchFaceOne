import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Application;

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

            private static var _timefont = -1 as Number;
            private static var _datefont = -1 as Number;

            static function Load() as Void
            {
                self.LoadDateFont();
                self.LoadTimeFont();

                self.Small = WatchUi.loadResource(Rez.Fonts.Small);
                if (IsSmallDisplay)
                {
                    self.Normal = Graphics.FONT_XTINY;
                    self.Tiny = self.Small;
                }
                else
                {
                    self.Normal = Graphics.FONT_TINY;
                    self.Tiny = WatchUi.loadResource(Rez.Fonts.Tiny);
                }
                self.Icons = WatchUi.loadResource(Rez.Fonts.Icons);
            }

            static function LoadDateFont() as Void
            {
                var datefont = Application.Properties.getValue("FDate") as Number;
                if (datefont == null)
                {
                    datefont = 0;
                }

                if (self._datefont == datefont)
                {
                    return;
                }
                self._datefont = datefont;

                self.Date = null;

                if (self._datefont != 2 && [
                    System.LANGUAGE_ARA,
                    System.LANGUAGE_HRV,
                    System.LANGUAGE_CES,
                    System.LANGUAGE_DAN,
                    System.LANGUAGE_DUT,
                    System.LANGUAGE_DEU,
                    System.LANGUAGE_ENG,
                    System.LANGUAGE_EST,
                    System.LANGUAGE_FIN,
                    System.LANGUAGE_FRE,
                    System.LANGUAGE_HEB,
                    System.LANGUAGE_HUN,
                    System.LANGUAGE_IND,
                    System.LANGUAGE_ITA,
                    System.LANGUAGE_LIT,
                    System.LANGUAGE_ZSM,
                    System.LANGUAGE_NOB,
                    System.LANGUAGE_POL,
                    System.LANGUAGE_POR,
                    System.LANGUAGE_RON,
                    System.LANGUAGE_SLO,
                    System.LANGUAGE_SLV,
                    System.LANGUAGE_SPA,
                    System.LANGUAGE_SWE,
                    System.LANGUAGE_TUR
                ].indexOf(System.getDeviceSettings().systemLanguage) >= 0)
                {
                    if (self._datefont == 0)
                    {
                        self.Date = WatchUi.loadResource(Rez.Fonts.DateFont);
                    }
                    else if (self._datefont == 1)
                    {
                        self.Date = WatchUi.loadResource(Rez.Fonts.DateGoD);
                    }
                }
                if (self.Date == null)
                {
                    self.Date = Graphics.FONT_TINY;
                }
            }

            static function LoadTimeFont() as Void
            {
                var timefont = Application.Properties.getValue("FTime") as Number;
                if (timefont == null)
                {
                    timefont = 0;
                }

                if (self._timefont == timefont)
                {
                    return;
                }
                self._timefont = timefont;
                
                if (self._timefont == 0)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.HourFont);
                    self.Minute = WatchUi.loadResource(Rez.Fonts.MinuteFont);
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.SecondsFont);
                }
                else if (self._timefont == 1)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.ConsolaHour);
                    if (Rez.Fonts has :ConsolaMinute)
                    {
                        self.Minute = WatchUi.loadResource(Rez.Fonts.ConsolaMinute);
                    }
                    else
                    {
                        self.Minute = self.Hour;
                    }
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.ConsolaSecond);
                }
                else if (self._timefont == 2)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.ImpossibleTime);
                    self.Minute = self.Hour;
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.ImpossibleSecond);
                }
                else if (self._timefont == 3)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.TimeKamikazoom);
                    self.Minute = self.Hour;
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.SecondKamikazoom);
                }
                else if (self._timefont == 4)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.HourRoboto);
                    if (Rez.Fonts has :MinuteRoboto)
                    {
                        self.Minute = WatchUi.loadResource(Rez.Fonts.MinuteRoboto);
                    }
                    else
                    {
                        self.Minute = self.Hour;
                    }
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.SecondRoboto);
                }
                else if (self._timefont == 5)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.TypesauceTime);
                    self.Minute = self.Hour;
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.TypesauceSecond);
                }
                else
                {
                    if (IsSmallDisplay)
                    {
                        self.Hour = Graphics.FONT_NUMBER_THAI_HOT;
                    }
                    else
                    {
                        self.Hour = Graphics.FONT_SYSTEM_NUMBER_MEDIUM;
                    }
                    self.Minute = self.Hour;
                    self.Seconds = Graphics.FONT_SYSTEM_XTINY;
                }
            }

            static function ResetTimeFonts()
            {
                Helper.Gfx.Fonts.Hour = Graphics.FONT_NUMBER_THAI_HOT;
                Helper.Gfx.Fonts.Minute = Graphics.FONT_NUMBER_THAI_HOT;
                Helper.Gfx.Fonts.Seconds = Graphics.FONT_TINY;
                Helper.Gfx.Fonts.Date = Graphics.FONT_MEDIUM;

                self._timefont = -1;
                self._datefont = -1;
            }
        }
    }
}