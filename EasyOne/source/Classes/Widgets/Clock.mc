import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;

module Widgets {
    class Clock extends WidgetBase {
        private var _showLeadingZero = true;

        function initialize(params as Dictionary) {
            WidgetBase.initialize(params, "Clock");
            self._showLeadingZero = (Helper.Properties.Get("ClZero", 1) as Number) > 0;
            $.Log(self.Name + " widget initialized");
        }

        function draw(dc as Gfx.Dc) as Void {
            if (HGfx.Fonts.Hour == null || HGfx.Fonts.Minute == null || HGfx.Fonts.Seconds == null) {
                return;
            }

            var clockTime = System.getClockTime();
            var hour = clockTime.hour;
            var m = clockTime.min.format("%02d");
            var h = hour.toString();
            var ampm = "";
            if (System.getDeviceSettings().is24Hour == false) {
                if (hour == 0) {
                    h = "12";
                    ampm = "AM";
                } else if (hour < 12) {
                    h = hour.toString();
                    ampm = "AM";
                } else if (hour == 12) {
                    h = "12";
                    ampm = "PM";
                } else {
                    h = (hour - 12).toString();
                    hour -= 12;
                    ampm = "PM";
                }
            }

            if (self._showLeadingZero == true && hour >= 0 && hour < 10) {
                h = "0" + h;
            }

            var settings = System.getDeviceSettings() as DeviceSettings;
            var space_min = (settings.screenWidth / 20).toNumber();
            var space_sec = (settings.screenWidth / 30).toNumber();
            var bigwidth = dc.getTextWidthInPixels(h, HGfx.Fonts.Hour);
            var bigwidth2 = dc.getTextWidthInPixels(m, HGfx.Fonts.Minute);
            var smallwidth = dc.getTextWidthInPixels("PM", HGfx.Fonts.Seconds);
            var width = bigwidth + bigwidth2 + space_min + space_sec + smallwidth;
            var center = ((dc.getWidth() - width) / 2).toNumber() + bigwidth + (space_min / 2).toNumber();

            var bigheight = Graphics.getFontAscent(HGfx.Fonts.Hour);
            var hours_posY = self.locY - (Graphics.getFontHeight(HGfx.Fonts.Hour) / 2).toNumber();

            var hours_pos = center - (space_min / 2).toNumber();
            var min_pos = center + (space_min / 2).toNumber();
            var sec_pos = min_pos + bigwidth2 + space_sec;

            var offset = HGfx.Fonts.Seconds instanceof Number ? 3 : 0;
            var sec_posY = self.locY - (bigheight / 2).toNumber() + offset;
            var amp_posY = self.locY + (bigheight / 2).toNumber() - Graphics.getFontAscent(HGfx.Fonts.Seconds) - Graphics.getFontDescent(HGfx.Fonts.Seconds) - offset;

            if (IsSmallDisplay) {
                if (HGfx.Fonts.TimeFontProp == 1 /*ConsolaMono*/) {
                    hours_posY -= 5;
                    sec_posY += 7;
                    amp_posY -= 8;
                } else if (HGfx.Fonts.TimeFontProp == 2 /*Impossible*/) {
                    hours_posY += 5;
                    sec_pos += 5;
                    sec_posY += 5;
                    amp_posY += 3;
                } else if (HGfx.Fonts.TimeFontProp == 3 /* Komikazoom */) {
                    sec_pos += 3;
                    sec_posY += 5;
                    amp_posY -= 2;
                } else if (HGfx.Fonts.TimeFontProp == 4 /* Roboto */) {
                    sec_posY += 3;
                    amp_posY -= 4;
                } else if (HGfx.Fonts.TimeFontProp == 5 /* Typesauce */) {
                    hours_posY += 10;
                    sec_posY += 5;
                    amp_posY += 7;
                }
            } else {
                if (HGfx.Fonts.TimeFontProp == 1 /*ConsolaMono*/) {
                    hours_posY -= 10;
                    sec_posY += 3;
                    sec_pos -= 8;
                    amp_posY -= 11;
                } else if (HGfx.Fonts.TimeFontProp == 2 /*Impossible*/) {
                    hours_posY += 4;
                    sec_pos += 5;
                    sec_posY += 5;
                    amp_posY += 2;
                } else if (HGfx.Fonts.TimeFontProp == 3 /* Komikazoom */) {
                    sec_pos += 5;
                    sec_posY += 5;
                    amp_posY -= 2;
                } else if (HGfx.Fonts.TimeFontProp == 4 /* Roboto */) {
                    hours_pos += 10;
                    sec_pos -= 8;
                    sec_posY += 2;
                    amp_posY -= 1;
                } else if (HGfx.Fonts.TimeFontProp == 5 /* Typesauce */) {
                    hours_posY += 10;
                    amp_posY += 8;
                }
            }

            dc.setColor(Themes.Colors.TimeHour, Gfx.COLOR_TRANSPARENT);
            dc.drawText(hours_pos, hours_posY, HGfx.Fonts.Hour, h, Gfx.TEXT_JUSTIFY_RIGHT);
            dc.setColor(Themes.Colors.TimeMinute, Gfx.COLOR_TRANSPARENT);
            dc.drawText(min_pos, hours_posY, HGfx.Fonts.Minute, m, Gfx.TEXT_JUSTIFY_LEFT);

            dc.setColor(Themes.Colors.TimeSecond, Gfx.COLOR_TRANSPARENT);
            dc.drawText(sec_pos, sec_posY, HGfx.Fonts.Seconds, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0) {
                dc.setColor(Themes.Colors.TimeAMPM, Gfx.COLOR_TRANSPARENT);
                dc.drawText(sec_pos, amp_posY, HGfx.Fonts.Seconds, ampm, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}
