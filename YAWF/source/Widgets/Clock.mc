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
        var FontBold = null;

        var WidgetPos = { "X" => 0, "Y" => 0 };
        var hours_pos = -1;
        var min_pos = -1;
        var sec_pos = -1;

        function initialize(params) 
        {
            Drawable.initialize(params);

            self.ClockColor = Application.Properties.getValue("ClockMainColor") as Number;
            self.SecondsColor = Application.Properties.getValue("ClockSecondsColor") as Number;
            self.Font = WatchUi.loadResource(Rez.Fonts.ClockFont);
            self.FontSmall = WatchUi.loadResource(Rez.Fonts.ClockFontSmall);
            self.FontBold = WatchUi.loadResource(Rez.Fonts.ClockFontBold);

            var posx = params.get(:PosX);
            var posy = params.get(:PosY);
            if (posx.equals("center"))
            {
                posx = getViewDC().getWidth() / 2;
            }
            if (posy.equals("center"))
            {
                posy = getViewDC().getHeight() / 2;
            }

            self.WidgetPos = { "X" => posx, "Y" => posy };
            self.CalcPos();
        }

        function draw(dc as Gfx.Dc) as Void 
        {
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

            dc.setColor(self.ClockColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self.hours_pos, self.WidgetPos["Y"], self.Font, hour.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(self.min_pos, self.WidgetPos["Y"], self.Font, clockTime.min.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_CENTER);

            dc.setColor(self.SecondsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self.sec_pos, self.WidgetPos["Y"] - 12, self.FontSmall, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);

            if (ampm.length() > 0)
            {
                dc.drawText(self.sec_pos, self.WidgetPos["Y"] + 20,self.FontBold, ampm, Gfx.TEXT_JUSTIFY_VCENTER | Gfx.TEXT_JUSTIFY_LEFT);
            }
        }

        private function CalcPos() as Void
        {
            var dc = getViewDC();
            var bigtextwidth = dc.getTextWidthInPixels("01", self.Font); //width of 2 numbers (monochrome)
            var space_between = 16; //Space between hour and min
            var space_seconds = 8; //Space between min and sec
            var offset = 32; //Offset to the left side            

            self.hours_pos = self.WidgetPos["X"] - (bigtextwidth / 2) - (space_between / 2) - offset;
            self.min_pos = self.WidgetPos["X"] + (bigtextwidth / 2) + (space_between / 2) - offset;
            self.sec_pos = self.WidgetPos["X"] - offset + bigtextwidth + (space_between / 2) + space_seconds;
        }
    }
}