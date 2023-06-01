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

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._hours_pos == null || self._min_pos == null)
            {
                var space_min = 10;
                var space_sec = 2;
                var bigwidth = dc.getTextWidthInPixels("55", HGfx.Fonts.Clock);
                var smallwidth = dc.getTextWidthInPixels("PM", HGfx.Fonts.ClockSmall);
                var width = (bigwidth * 2) + space_min + space_sec + smallwidth;

                var center = ((dc.getWidth() - width) / 2) + bigwidth + (space_min / 2);

                self._hours_pos = center - (space_min / 2);
                self._min_pos = center + (space_min / 2);
            }

            var clockTime = System.getClockTime();
            var hour = clockTime.hour;

            var m = clockTime.min.format("%02d");
            var h = hour.format("%02d");

            var ampm = "";
            if (System.getDeviceSettings().is24Hour == false)
            {
                if (hour < 12)
                {
                    ampm = "AM";
                    h = hour;//no leading 0
                }
                else
                {
                    ampm = "PM";
                }
                hour %= 12;
            }
            
            dc.setColor(self._theme.ClockHourColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._hours_pos, self.locY, HGfx.Fonts.Clock, h, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_RIGHT);
            dc.setColor(self._theme.ClockMinutesColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._min_pos, self.locY, HGfx.Fonts.Clock, m, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            var minwidth = dc.getTextWidthInPixels(m, HGfx.Fonts.Clock);
            var secpos = self._min_pos + dc.getTextWidthInPixels(m, HGfx.Fonts.Clock) + 2;

            dc.setColor(self._theme.ClockSecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(secpos, self.locY - 16, HGfx.Fonts.ClockSmall, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.drawText(secpos, self.locY + 16,HGfx.Fonts.ClockSmall, ampm, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}