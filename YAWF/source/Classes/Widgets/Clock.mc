using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

module Widgets 
{
    class Clock extends WidgetBase
    {
        private var _Font = null as FontResource;
        private  var _FontSmall = null as FontResource;
        private var _FontBold = null as FontResource;

        private var _hours_pos = -1 as Number;
        private var _min_pos = -1 as Number;
        private var _sec_pos = -1 as Number;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            
            self._Font = WatchUi.loadResource(Rez.Fonts.ClockFont) as FontResource;
            self._FontSmall = WatchUi.loadResource(Rez.Fonts.ClockFontSmall) as FontResource;
            self._FontBold = WatchUi.loadResource(Rez.Fonts.ClockFontBold) as FontResource;
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._initialized == false)
            {
                self.CalcPos(dc);
            }

            var clockTime = System.getClockTime();
            var hour = clockTime.hour;
            var ampm = "";
            if (System.getDeviceSettings().is24Hour == false)
            {
                if (hour < 12)
                {
                    ampm = "AM";
                }
                else
                {
                    ampm = "PM";
                }
                hour %= 12;
            }

            dc.setColor(self._theme.ClockMainColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._hours_pos, self.locY, self._Font, hour.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(self._min_pos, self.locY, self._Font, clockTime.min.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);

            dc.setColor(self._theme.ClockSecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._sec_pos, self.locY - 12, self._FontSmall, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.drawText(self._sec_pos, self.locY + 20,self._FontBold, ampm, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
            }
        }

        private function CalcPos(dc as Gfx.Dc) as Void
        {
            var bigtextwidth = dc.getTextWidthInPixels("01", self._Font); //width of 2 numbers (monochrome)
            var space_between = 16; //Space between hour and min
            var space_seconds = 8; //Space between min and sec
            var offset = 32; //Offset to the left side            

            self._hours_pos = self.locX - (bigtextwidth / 2) - (space_between / 2) - offset;
            self._min_pos = self.locX + (bigtextwidth / 2) + (space_between / 2) - offset;
            self._sec_pos = self.locX - offset + bigtextwidth + (space_between / 2) + space_seconds;

            self._initialized = true;
        }
    }
}