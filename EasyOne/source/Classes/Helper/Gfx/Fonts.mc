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

            static var TimeFontRez = -1 as Number;
            static var DateFontRez = -1 as Number;

            static function Load() as Void
            {
                self.LoadDateFont();
                self.LoadTimeFont();
                self.Small = WatchUi.loadResource(Rez.Fonts.Small);
                if (IsSmallDisplay)
                {
                    self.Normal = Graphics.FONT_TINY;
                }
                else
                {
                    self.Normal = WatchUi.loadResource(Rez.Fonts.Normal);
                }

                if (Rez.Fonts has :Tiny)
                {
                    self.Tiny = WatchUi.loadResource(Rez.Fonts.Tiny);
                }
                else
                {
                    self.Tiny = self.Small;
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

                if (self.DateFontRez == datefont)
                {
                    return;
                }
                self.DateFontRez = datefont;

                self.Date = null;
                var systemlang = System.getDeviceSettings().systemLanguage;

                if (self.DateFontRez != 99)
                {
                    if ([
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
                        System.LANGUAGE_LAV,
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
                    ].indexOf(systemlang) >= 0)
                    {
                        if (self.DateFontRez == 0)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.KamikazoomDate);
                        }
                        else if (self.DateFontRez == 1)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.GoDDate);
                        }
                        else if (self.DateFontRez == 2)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.TroikaDate);
                        }
                        else if (self.DateFontRez == 90)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.RobotoDate);
                        }
                    }
                    else if (systemlang == System.LANGUAGE_VIE && self.DateFontRez == 90)
                    {
                        self.Date = WatchUi.loadResource(Rez.Fonts.RobotoDate);
                    }
                    else if (systemlang == System.LANGUAGE_GRE)
                    {
                        if (self.DateFontRez == 2)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.TroikaDateGreek);
                        }
                        else if (self.DateFontRez == 90)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.RobotoDateGreek);
                        }
                    }
                    else if ([System.LANGUAGE_BUL, System.LANGUAGE_RUS, System.LANGUAGE_UKR].indexOf(systemlang) >= 0)
                    {
                        if (self.DateFontRez == 2)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.TroikaDateCyrillic);
                        }
                        else if (self.DateFontRez == 90)
                        {
                            self.Date = WatchUi.loadResource(Rez.Fonts.RobotoDateCyrillic);
                        }
                    }
                }
                
                if (self.Date == null)
                {
                    self.DateFontRez = 99;
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

                if (self.TimeFontRez == timefont)
                {
                    return;
                }
                self.TimeFontRez = timefont;
                
                if (self.TimeFontRez == 0)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.Hour);
                    self.Minute = WatchUi.loadResource(Rez.Fonts.Minute);
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.Seconds);
                }
                else if (self.TimeFontRez == 1)
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
                else if (self.TimeFontRez == 2)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.ImpossibleTime);
                    self.Minute = self.Hour;
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.ImpossibleSecond);
                }
                else if (self.TimeFontRez == 3)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.KamikazoomTime);
                    self.Minute = self.Hour;
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.KamikazoomSecond);
                }
                else if (self.TimeFontRez == 4)
                {
                    self.Hour = WatchUi.loadResource(Rez.Fonts.RobotoHour);
                    if (Rez.Fonts has :RobotoMinute)
                    {
                        self.Minute = WatchUi.loadResource(Rez.Fonts.RobotoMinute);
                    }
                    else
                    {
                        self.Minute = self.Hour;
                    }
                    self.Seconds = WatchUi.loadResource(Rez.Fonts.RobotoSecond);
                }
                else if (self.TimeFontRez == 5)
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
                        self.Hour = Graphics.FONT_NUMBER_MEDIUM;
                    }
                    self.Minute = self.Hour;
                    self.Seconds = Graphics.FONT_SYSTEM_XTINY;
                    self.Seconds = Graphics.FONT_XTINY;
                }
            }

            static function ResetTimeFonts()
            {
                Helper.Gfx.Fonts.Hour = Graphics.FONT_NUMBER_THAI_HOT;
                Helper.Gfx.Fonts.Minute = Graphics.FONT_NUMBER_THAI_HOT;
                Helper.Gfx.Fonts.Seconds = Graphics.FONT_TINY;
                Helper.Gfx.Fonts.Date = Graphics.FONT_MEDIUM;

                self.TimeFontRez = -1;
                self.DateFontRez = -1;
            }
        }
    }
}