using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

module Widgets 
{
    class Clock extends WidgetBase
    {
        private var _Font = null as FontResource;
        private var _FontSmall = null as FontResource;

        private var _hours_pos = null as Number;
        private var _min_pos = null as Number;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            
            self._Font = WatchUi.loadResource(Rez.Fonts.ClockFont) as FontResource;
            self._FontSmall = WatchUi.loadResource(Rez.Fonts.ClockFontSmall) as FontResource;
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._hours_pos == null || self._min_pos == null)
            {
                self._hours_pos = self.locX - 6 - 30;
                self._min_pos = self.locX + 6 - 30;
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
            dc.drawText(self._hours_pos, self.locY, self._Font, h, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_RIGHT);
            dc.setColor(self._theme.ClockMinutesColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._min_pos, self.locY, self._Font, m, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            var minwidth = dc.getTextWidthInPixels(m, self._Font);
            var secpos = self._min_pos + dc.getTextWidthInPixels(m, self._Font) + 2;

            dc.setColor(self._theme.ClockSecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(secpos, self.locY - 18, self._FontSmall, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.drawText(secpos, self.locY + 18,self._FontSmall, ampm, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}