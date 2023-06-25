using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets 
{
    class Clock extends WidgetBase
    {
        private var _hours_pos = null as Number;
        private var _min_pos = null as Number;
        private var _sec_posX = null as Number;
        private var _sec_posY = null as Number;
        private var _amp_posY = null as Number;

        private var _showLeadingZero = true;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            var setting = Application.Properties.getValue("ClockLeadingZero") as Number;
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
            if (self._hours_pos == null)
            {
                var space_min = 10;
                var space_sec = 6;
                var bigwidth = dc.getTextWidthInPixels("99", HGfx.Fonts.Hour);
                var bigwidth2 = dc.getTextWidthInPixels("99", HGfx.Fonts.Minute);
                var smallwidth = dc.getTextWidthInPixels("PM", HGfx.Fonts.Seconds);
                var width = bigwidth + bigwidth2 + space_min + space_sec + smallwidth;
                var center = ((dc.getWidth() - width) / 2) + bigwidth + (space_min / 2);

                self._hours_pos = center - (space_min / 2);
                self._min_pos = center + (space_min / 2);
                self._sec_posX = self._min_pos + bigwidth2 + space_sec;

                self._sec_posY = (self.locY - (dc.getFontHeight(HGfx.Fonts.Minute) / 2));
                self._sec_posY -= 1;
                self._amp_posY = self.locY + (dc.getFontHeight(HGfx.Fonts.Minute) / 2) - dc.getFontHeight(HGfx.Fonts.Seconds);
                self._amp_posY += 1;
            }

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
            dc.setColor(self._theme.ClockHourColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._hours_pos, self.locY, HGfx.Fonts.Hour, h, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_RIGHT);
            dc.setColor(self._theme.ClockMinutesColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._min_pos, self.locY, HGfx.Fonts.Minute, m, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            dc.setColor(self._theme.ClockSecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._sec_posX, self._sec_posY, HGfx.Fonts.Seconds, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.drawText(self._sec_posX, self._amp_posY, HGfx.Fonts.Seconds, ampm, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}