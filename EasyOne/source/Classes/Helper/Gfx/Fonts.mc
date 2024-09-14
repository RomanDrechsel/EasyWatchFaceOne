import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Application;

module Helper {
    module Gfx {
        class Fonts {
            static var Hour as Graphics.FontType? = null;
            static var Minute as Graphics.FontType? = null;
            static var Seconds as Graphics.FontType? = null;
            static var Date as Graphics.FontType? = null;
            static var Normal as Graphics.FontType? = null;
            static var Small as Graphics.FontType? = null;
            static var Tiny as Graphics.FontType? = null;
            static var Icons as Graphics.FontType? = null;

            static var DateFontProp = -999;
            static var TimeFontProp = -999;

            static function Load(delayed as Boolean) as Void {
                //date font
                var prop = Helper.Properties.Get("FDate", -1) as Number;
                if (prop != self.DateFontProp) {
                    if (delayed) {
                        self.Date = Graphics.FONT_TINY;
                        if ($.getView().OneTimePerTick == null) {
                            $.getView().OneTimePerTick = [1];
                        }
                        $.getView().OneTimePerTick.add(new Lang.Method(self, :loadDateFont));
                    } else {
                        self.loadDateFont(prop);
                    }
                }

                //Time fonts
                prop = Helper.Properties.Get("FTime", -1) as Number;
                if (prop != self.TimeFontProp) {
                    if (delayed) {
                        self.Hour = Graphics.FONT_NUMBER_THAI_HOT;
                        self.Minute = self.Hour;
                        self.Seconds = Graphics.FONT_XTINY;

                        if ($.getView().OneTimePerTick == null) {
                            $.getView().OneTimePerTick = [1];
                        }
                        $.getView().OneTimePerTick.add(new Lang.Method(self, :loadTimeFont));
                    } else {
                        self.loadTimeFont(prop);
                    }
                }

                //texts
                self.Small = WatchUi.loadResource(Rez.Fonts.Small);
                if (Rez.Fonts has :Normal) {
                    self.Normal = WatchUi.loadResource(Rez.Fonts.Normal);
                } else {
                    self.Normal = Graphics.FONT_TINY;
                }

                if (Rez.Fonts has :Tiny) {
                    self.Tiny = WatchUi.loadResource(Rez.Fonts.Tiny);
                } else {
                    self.Tiny = self.Small;
                }

                self.Icons = WatchUi.loadResource(Rez.Fonts.Icons);
            }

            static function loadDateFont(prop as Number) as Void {
                if (prop == null) {
                    prop = Helper.Properties.Get("FDate", -1) as Number;
                }

                var rez = self.getDateFontRez(prop);
                if (rez.size() > 1) {
                    $.Log("Could not load font " + rez.toString());
                    if (WatchUi has :showToast) {
                        var txt = Application.loadResource(Rez.Strings.FError) as String;
                        if (txt.length() > 0) {
                            WatchUi.showToast(txt, { :icon => Rez.Drawables.Attention });
                        }
                    }
                }
                self.Date = null;

                if (rez[0] instanceof Lang.ResourceId) {
                    self.Date = WatchUi.loadResource(rez[0]);
                }

                if (self.Date == null) {
                    if (System.getDeviceSettings().systemLanguage == System.LANGUAGE_THA) {
                        self.Date = Graphics.FONT_LARGE;
                    } else {
                        self.Date = Graphics.FONT_TINY;
                    }
                }
            }

            static function loadTimeFont(prop as Number) as Void {
                if (prop == null) {
                    prop = Helper.Properties.Get("FTime", -1) as Number;
                }

                var rez = self.getTimeFontRez(prop);
                if (rez[0] instanceof Lang.ResourceId) {
                    self.Hour = WatchUi.loadResource(rez[0]);
                }
                if (self.Hour == null) {
                    if (IsSmallDisplay) {
                        self.Hour = Graphics.FONT_NUMBER_THAI_HOT;
                    } else {
                        self.Hour = Graphics.FONT_NUMBER_MEDIUM;
                    }
                }

                if (rez[1] instanceof Lang.ResourceId) {
                    if (rez[0] == rez[1]) {
                        self.Minute = self.Hour;
                    } else {
                        self.Minute = WatchUi.loadResource(rez[1]);
                    }
                }
                if (self.Minute == null) {
                    self.Minute = self.Hour;
                }

                if (rez[2] instanceof Lang.ResourceId) {
                    self.Seconds = WatchUi.loadResource(rez[2]);
                }
                if (self.Seconds == null) {
                    self.Seconds = Graphics.FONT_XTINY;
                }
            }

            private static function getDateFontRez(prop as Number) as Array<Lang.ResourceId?> {
                var systemlang = System.getDeviceSettings().systemLanguage;

                if (prop < -1) {
                    if ([System.LANGUAGE_GRE, System.LANGUAGE_BUL, System.LANGUAGE_RUS, System.LANGUAGE_UKR].indexOf(systemlang) >= 0) {
                        prop = 2;
                    } else if (systemlang == System.LANGUAGE_VIE) {
                        prop = 50;
                    } else if ([System.LANGUAGE_CHS, System.LANGUAGE_CHT, System.LANGUAGE_JPN, System.LANGUAGE_KOR].indexOf(systemlang) >= 0) {
                        prop = 70;
                    } else if (systemlang == System.LANGUAGE_THA) {
                        prop = 80;
                    } else {
                        prop = 0;
                    }

                    Application.Properties.setValue("FDate", prop);
                }

                self.DateFontProp = prop;

                if (prop >= 0) {
                    if (
                        [
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
                            System.LANGUAGE_TUR,
                        ].indexOf(systemlang) >= 0
                    ) {
                        if (prop == 0) {
                            return [Rez.Fonts.KomikazoomDate];
                        } else if (prop == 1) {
                            return [Rez.Fonts.GoDDate];
                        } else if (prop == 2) {
                            return [Rez.Fonts.TroikaDate];
                        } else if (prop == 50) {
                            return [Rez.Fonts.RobotoDate];
                        } else if (prop > 0) {
                            Application.Properties.setValue("FDate", 0);
                            self.DateFontProp = 0;
                            return [Rez.Fonts.KomikazoomDate, false];
                        }
                    } else if (systemlang == System.LANGUAGE_VIE && prop == 50) {
                        return [Rez.Fonts.RobotoDate];
                    } else if (systemlang == System.LANGUAGE_GRE) {
                        if (prop == 2) {
                            return [Rez.Fonts.TroikaDateGreek];
                        } else if (prop == 50) {
                            return [Rez.Fonts.RobotoDateGreek];
                        } else if (prop > 0) {
                            Application.Properties.setValue("FDate", 2);
                            self.DateFontProp = 2;
                            return [Rez.Fonts.TroikaDateGreek, false];
                        }
                    } else if ([System.LANGUAGE_BUL, System.LANGUAGE_RUS, System.LANGUAGE_UKR].indexOf(systemlang) >= 0) {
                        if (prop == 2) {
                            return [Rez.Fonts.TroikaDateCyrillic];
                        } else if (prop == 50) {
                            return [Rez.Fonts.RobotoDateCyrillic];
                        } else if (prop > 0) {
                            Application.Properties.setValue("FDate", 2);
                            self.DateFontProp = 2;
                            return [Rez.Fonts.TroikaDateCyrillic, false];
                        }
                    } else if ([System.LANGUAGE_CHS, System.LANGUAGE_CHT, System.LANGUAGE_JPN, System.LANGUAGE_KOR].indexOf(systemlang) >= 0) {
                        if (prop == 70) {
                            return [Rez.Fonts.NotoDateLogogram];
                        }
                    } else if (systemlang == System.LANGUAGE_THA) {
                        if (prop == 80) {
                            return [Rez.Fonts.KanitDateThai];
                        } else if (prop > 0) {
                            self.DateFontProp = 80;
                            Application.Properties.setValue("FDate", 80);
                        }
                    }
                }

                self.DateFontProp = -1;
                return [null];
            }

            private static function getTimeFontRez(prop as Number) as Array<Lang.ResourceId?> {
                self.TimeFontProp = prop;
                if (prop == 0) {
                    return [Rez.Fonts.Hour, Rez.Fonts.Minute, Rez.Fonts.Seconds];
                } else if (prop == 1) {
                    var ret = [Rez.Fonts.ConsolaHour];
                    if (Rez.Fonts has :ConsolaMinute) {
                        ret.add(Rez.Fonts.ConsolaMinute);
                    } else {
                        ret.add(Rez.Fonts.ConsolaHour);
                    }
                    ret.add(Rez.Fonts.ConsolaSecond);
                    return ret;
                } else if (prop == 2) {
                    return [Rez.Fonts.ImpossibleTime, Rez.Fonts.ImpossibleTime, Rez.Fonts.ImpossibleSecond];
                } else if (prop == 3) {
                    return [Rez.Fonts.KamikazoomTime, Rez.Fonts.KamikazoomTime, Rez.Fonts.KamikazoomSecond];
                } else if (prop == 4) {
                    var ret = [Rez.Fonts.RobotoHour];
                    if (Rez.Fonts has :RobotoMinute) {
                        ret.add(Rez.Fonts.RobotoMinute);
                    } else {
                        ret.add(Rez.Fonts.RobotoHour);
                    }
                    ret.add(Rez.Fonts.RobotoSecond);
                    return ret;
                } else if (prop == 5) {
                    return [Rez.Fonts.TypesauceTime, Rez.Fonts.TypesauceTime, Rez.Fonts.TypesauceSecond];
                } else {
                    if (prop > 0) {
                        Application.Properties.getValue("FTime", -1);
                    }
                    self.TimeFontProp = -1;
                    return [null, null, null];
                }
            }
        }
    }
}
