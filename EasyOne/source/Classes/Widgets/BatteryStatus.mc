using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets 
{
    class BatteryStatus extends WidgetBase
    {        
        private var _arcStart = 220;
        private var _arcLength = 230.0;

        private var _arcRadius = 35;
        private var _arcWidth = 9;

        private var _arcParts = 6;
        private var _arcPartSeparatorWidth = 5;

        private var _arc = null as Helper.Gfx.DrawArc;

        private var _Font = null as FontResource;
        private var _FontHeight = 1;
        private var _hasBatteryInDays = false;

        private var _BatteryDays = "d";

        private var _initialized = false;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            if (IsSmallDisplay())
            {
                self._arcRadius *= .7;
                self._arcWidth = 6;
                self._arcPartSeparatorWidth = 3;
                self._hasBatteryInDays = false;
            }
            else
            {
                self._hasBatteryInDays = System.getSystemStats() has :batteryInDays;
                var showdays = Application.Properties.getValue("WidgetBatteryShowDays") as Number;
                if (showdays != null && showdays <= 0)
                {
                    self._hasBatteryInDays = false;
                }
            }

            if (self._hasBatteryInDays == true)
            {
                self._Font = HGfx.Fonts.Tiny;
                self._BatteryDays = Application.loadResource(Rez.Strings.ShortBatteryDays) as String;
            }
            else
            {
                self._Font = HGfx.Fonts.Small;
            } 
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            if (self._initialized == false)
            {
                self.Init(dc);
            }

            //Background
            self._arc.draw(dc, 100, self._theme.BatteryIndicatorBackgroundColor);

            //colored battery status
            var stats = System.getSystemStats();
            var battery = stats.battery;
            var color = self._theme.BatteryIndicatorFullColor;

            if (stats.battery < 20.0 || (self._hasBatteryInDays && stats.batteryInDays < 1.0))
            {
                color = self._theme.BatteryIndicatorLowColor;
            }
            else if (stats.battery < 40.0 || (self._hasBatteryInDays && stats.batteryInDays < 2.0))
            {
                color = self._theme.BatteryIndicatorHalfColor;
            }

            self._arc.draw(dc, battery, color);

            dc.setColor(color, Gfx.COLOR_TRANSPARENT);
            if (self._hasBatteryInDays == true)
            {
                dc.drawText(self.locX, self.locY - self._FontHeight + 2, self._Font, battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER);
                dc.drawText(self.locX, self.locY - 2, self._Font, stats.batteryInDays.format("%2d") + self._BatteryDays, Gfx.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.drawText(self.locX, self.locY - 3, self._Font, battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }            
        }

        private function Init(dc as Gfx.Dc)
        {
            //adjust position to center of widget
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = (self.locX - (self._arcRadius / 2) - (self._arcWidth / 2) - 8).toFloat();
            }
            else if (self.Justification == WIDGET_JUSTIFICATION_LEFT)
            {
                self.locX = (self.locX + self._arcRadius + (self._arcWidth / 2) + 3).toFloat();
            }

            self.locY = (self.locY + self._arcRadius + (self._arcWidth / 2) + 3).toFloat();

            self._arc = new Helper.Gfx.DrawArc(self.locX, self.locY, self._arcRadius, self._arcWidth, self._arcStart, self._arcLength, Gfx.ARC_CLOCKWISE);
            self._arc.Parts = self._arcParts;
            self._arc.PartSeparatorWidth = self._arcPartSeparatorWidth;

            self._FontHeight = dc.getFontHeight(self._Font);
            self._initialized = true;
        }
    }
}