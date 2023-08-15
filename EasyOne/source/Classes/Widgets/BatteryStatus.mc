using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets 
{
    class BatteryStatus extends WidgetBase
    {
        private var _arcRadius = 35;
        private var _arcWidth = 9;
        private var _arcPartSeparatorWidth = 5;
        private var _arcStart = 220.0;
        private var _arcDirection = Gfx.ARC_CLOCKWISE;

        private var _Font = null as FontResource;
        private var _FontHeight = 1;
        private var _hasBatteryInDays = false;
        private var _BatteryDays = "d";
        private var _initialized = false;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            if (IsSmallDisplay)
            {
                self._arcRadius *= .7;
                self._arcWidth = 6;
                self._arcPartSeparatorWidth = 3;
                self._hasBatteryInDays = false;
            }
            else
            {
                self._hasBatteryInDays = System.getSystemStats() has :batteryInDays;
                var showdays = Application.Properties.getValue("BatDays") as Number;
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
            var theme = $.getTheme();
            dc.setColor(theme.BatteryIndicatorBackgroundColor, Gfx.COLOR_TRANSPARENT);
            self.drawArc(dc, 100.0);

            //colored battery status
            var stats = System.getSystemStats();
            var color = theme.BatteryIndicatorFullColor;

            if (stats.battery < 20.0)
            {
                color = theme.BatteryIndicatorLowColor;
            }
            else if (stats.battery < 40.0)
            {
                color = theme.BatteryIndicatorHalfColor;
            }

            dc.setColor(color, Gfx.COLOR_TRANSPARENT);

            self.drawArc(dc, stats.battery);

            if (self._hasBatteryInDays == true)
            {
                dc.drawText(self.locX, self.locY - dc.getFontHeight(self._Font) + 2, self._Font, stats.battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER);
                dc.drawText(self.locX, self.locY - 2, self._Font, stats.batteryInDays.format("%2d") + self._BatteryDays, Gfx.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.drawText(self.locX, self.locY - 3, self._Font, stats.battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }            
        }

        private function Init(dc as Gfx.Dc)
        {
            //adjust position to center of widget
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = (self.locX - (self._arcRadius / 2) - (self._arcWidth / 2) - 8).toFloat();
                self._arcDirection = Gfx.ARC_COUNTER_CLOCKWISE;
                self._arcStart = -40.0;
            }
            else if (self.Justification == WIDGET_JUSTIFICATION_LEFT)
            {
                self.locX = (self.locX + self._arcRadius + (self._arcWidth / 2) + 3).toFloat();
            }

            self.locY = (self.locY + self._arcRadius + (self._arcWidth / 2) + 3).toFloat();

            self._initialized = true;
        }

        private function drawArc(dc as Gfx.Dc, percent as Float) as Void
        {
            var arcFactor = 1.0;
            if (self._arcDirection == Gfx.ARC_COUNTER_CLOCKWISE)
            {
                arcFactor = -1.0;
            }

            var arcLength = 230.0;
            var arcParts = 6;
            
            var length = arcLength * percent / 100.0;
            var end = self._arcStart - (length * arcFactor);

            dc.setPenWidth(self._arcWidth);

            var deg = self._arcStart;
            var partdeg = arcLength / arcParts;
            partdeg -= self._arcPartSeparatorWidth;

            for (var i = 0; i < arcParts; i++)
            {
                var partend = deg - (partdeg * arcFactor);
                if (i == arcParts - 1)
                {
                    partend -= self._arcPartSeparatorWidth * arcFactor;
                }
                if (self._arcDirection == Gfx.ARC_COUNTER_CLOCKWISE)
                {
                    if (partend > end)
                    {
                        partend = end;
                    }
                }
                else
                {
                    if (partend < end)
                    {
                        partend = end;
                    }
                }

                if (deg.toNumber() == partend.toNumber())
                {
                    continue;
                }
                
                dc.drawArc(self.locX, self.locY, self._arcRadius, self._arcDirection, deg, partend);
                deg -= (partdeg + self._arcPartSeparatorWidth) * arcFactor;
                if (self._arcDirection == Gfx.ARC_COUNTER_CLOCKWISE)
                {
                    if (deg >= end)
                    {
                        break;
                    }
                }
                else
                {
                    if (deg <= end)
                    {
                        break;
                    }
                }                    
            }
        }
    }
}