import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;

module Widgets 
{
    class Clock extends WidgetBase
    {
        private var _showLeadingZero = true;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            var setting = Application.Properties.getValue("ClZero") as Number;
            if (setting != null && setting <= 0)
            {
                self._showLeadingZero = false;
            }
            else
            {
                self._showLeadingZero = true;
            }
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            var settings = System.getDeviceSettings() as DeviceSettings;
            var space_min = settings.screenWidth / 20;
            var space_sec = settings.screenWidth / 30;
            var bigwidth = dc.getTextWidthInPixels("99", HGfx.Fonts.Hour);
            var bigwidth2 = dc.getTextWidthInPixels("99", HGfx.Fonts.Minute);
            var smallwidth = dc.getTextWidthInPixels("PM", HGfx.Fonts.Seconds);
            var width = bigwidth + bigwidth2 + space_min + space_sec + smallwidth;
            var center = ((dc.getWidth() - width) / 2) + bigwidth + (space_min / 2);

            var bigheight = Graphics.getFontAscent(HGfx.Fonts.Hour);
            var hours_posY = self.locY - (Graphics.getFontHeight(HGfx.Fonts.Hour) / 2);

            var hours_pos = center - (space_min / 2);
            var min_pos = center + (space_min / 2);
            var sec_pos = min_pos + bigwidth2 + space_sec;
            
            var sec_posY = self.locY - (bigheight / 2);
            var amp_posY = self.locY + (bigheight / 2) - Graphics.getFontAscent(HGfx.Fonts.Seconds) - Graphics.getFontDescent(HGfx.Fonts.Seconds);

            var clockTime = System.getClockTime();
            var hour = clockTime.hour;

            var m = clockTime.min.format("%02d");
            var h = hour.format("%02d");

            var ampm = "";
            if (System.getDeviceSettings().is24Hour == false)
            {
                if (hour == 0)
                {
                    h = 12;
                    ampm = "AM";
                }
                else if (hour < 12)
                {
                    h = hour;
                    ampm = "AM";
                }
                else if (hour == 12)
                {
                    h = 12;
                    ampm = "PM";
                }
                else
                {
                    h = hour - 12;
                    hour -= 12;
                    ampm = "PM";
                }

                if (self._showLeadingZero == true && hour > 0 && hour < 10)
                {
                    h = "0" + h;
                }
            }

            dc.setColor(Themes.Colors.TimeHour, Gfx.COLOR_TRANSPARENT);
            dc.drawText(hours_pos, hours_posY, HGfx.Fonts.Hour, h, Gfx.TEXT_JUSTIFY_RIGHT);
            dc.setColor(Themes.Colors.TimeMinute, Gfx.COLOR_TRANSPARENT);
            dc.drawText(min_pos, hours_posY, HGfx.Fonts.Minute, m, Gfx.TEXT_JUSTIFY_LEFT);

            dc.setColor(Themes.Colors.TimeSecond, Gfx.COLOR_TRANSPARENT);
            dc.drawText(sec_pos, sec_posY, HGfx.Fonts.Seconds, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.setColor(Themes.Colors.TimeAMPM, Gfx.COLOR_TRANSPARENT);
                dc.drawText(sec_pos, amp_posY, HGfx.Fonts.Seconds, ampm, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}