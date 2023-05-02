import Toybox.Application;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

module Widgets 
{
    class Clock extends WatchUi.Drawable
    {
        var ClockColor = 0xFFFFFF;
        var SecondsColor = 0xFFFFFF;
        var Font = null;
        var FontSmall = null;

        var hours_pos = -1;
        var min_pos = -1;
        var sec_pos = -1;

        function initialize(params) 
        {
            Drawable.initialize(params);

            self.ClockColor = getApp().getProperty("ClockMainColor") as Number;
            self.SecondsColor = getApp().getProperty("ClockSecondsColor") as Number;
            self.Font = WatchUi.loadResource(Rez.Fonts.ClockFont);
            self.FontSmall = WatchUi.loadResource(Rez.Fonts.ClockFontSmall);
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self.hours_pos < 0)
            {
                self.CalcPos(dc);
            }

            var clockTime = System.getClockTime();

            dc.setColor(self.ClockColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self.hours_pos, dc.getHeight() / 2, self.Font, clockTime.hour.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(self.min_pos, dc.getHeight() / 2, self.Font, clockTime.min.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);

            dc.setColor(self.SecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self.sec_pos, (dc.getHeight() / 2) - 12, self.FontSmall, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
        }

        private function CalcPos(dc as Gfx.Dc) as Void
        {
            var bigtextwidth = dc.getTextWidthInPixels("01", self.Font); //width of 2 numbers (monochrome)
            var space_between = 16; //Space between hour and min
            var space_seconds = 14; //Space betreen min and sec
            var offset = 32; //Offset to the left side            

            self.hours_pos = (dc.getWidth() / 2) - (bigtextwidth / 2) - (space_between/2) - offset;
            self.min_pos = (dc.getWidth() / 2) + (bigtextwidth / 2) + (space_between/2) - offset;
            self.sec_pos = (dc.getWidth() / 2) - offset + bigtextwidth + space_seconds;
        }
    }
}