import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets 
{
    class BatteryStatus extends WidgetBase
    {
        private var _Font = null as FontResource;
        private var _hasBatteryInDays = false;
        private var _BatteryDays = null;
        private var _arcRadius = 35;
        private var _arcWidth = 9;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            if (IsSmallDisplay)
            {
                self._hasBatteryInDays = false;
                self._arcRadius = 25;
                self._arcWidth = 6;
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
                self._BatteryDays = Application.loadResource(Rez.Strings.ShortBatteryDays) as String;
            }

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
        }

        function draw(dc as Dc) as Void 
        {
            //Background
            var theme = $.getTheme();
            dc.setColor(theme.BatteryIndicatorBackgroundColor, Graphics.COLOR_TRANSPARENT);
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

            dc.setColor(color, Graphics.COLOR_TRANSPARENT);

            self.drawArc(dc, stats.battery);

            if (self._hasBatteryInDays == true)
            {
                dc.drawText(self.locX, self.locY - dc.getFontHeight(HGfx.Fonts.Tiny) + 2, HGfx.Fonts.Tiny, stats.battery.format("%2d") + "%", Graphics.TEXT_JUSTIFY_CENTER);
                dc.drawText(self.locX, self.locY - 2, HGfx.Fonts.Tiny, stats.batteryInDays.format("%2d") + self._BatteryDays, Graphics.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.drawText(self.locX, self.locY - 3, HGfx.Fonts.Small, stats.battery.format("%2d") + "%", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }            
        }

        private function drawArc(dc as Dc, percent as Float) as Void
        {
            var arcLength = 230.0;
            var arcParts = 6;

            var arcStart = 220;
            var arcFactor = 1.0;
            var arcDirection = Graphics.ARC_CLOCKWISE;
           
            var arcPartSeparatorWidth = 5;

            if (IsSmallDisplay)  
            {
                arcPartSeparatorWidth = 3;
            }

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                arcFactor = -1.0;
                arcDirection = Graphics.ARC_COUNTER_CLOCKWISE;
                arcStart = -40.0;
            }
            
            var length = arcLength * percent / 100.0;
            var end = arcStart - (length * arcFactor);

            dc.setPenWidth(self._arcWidth);

            var deg = arcStart;
            var partdeg = arcLength / arcParts;
            partdeg -= arcPartSeparatorWidth;

            for (var i = 0; i < arcParts; i++)
            {
                var partend = deg - (partdeg * arcFactor);
                if (i == arcParts - 1)
                {
                    partend -= arcPartSeparatorWidth * arcFactor;
                }
                if (arcDirection == Graphics.ARC_COUNTER_CLOCKWISE)
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
                
                dc.drawArc(self.locX, self.locY, self._arcRadius, arcDirection, deg, partend);
                deg -= (partdeg + arcPartSeparatorWidth) * arcFactor;
                if (arcDirection == Graphics.ARC_COUNTER_CLOCKWISE)
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