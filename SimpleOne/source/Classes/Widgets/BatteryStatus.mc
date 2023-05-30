using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;

module Widgets 
{
    class BatteryStatus extends WidgetBase
    {        
        private var _arcStart = 220 as Number;
        private var _arcLength = 230 as Float;

        private var _arcRadius = 35 as Number;
        private var _arcWidth = 9 as Number;
        private var _arcSection = 10 as Number;

        private var _arcParts = 6 as Number;
        private var _arcPartSeparatorWidth = 5 as Number;

        private var _arc = null as Helper.Gfx.DrawArc;

        private var _Font = null as FontResource;
        private var _FontHeight = 1 as Number;
        private var _hasBatteryInDays = false;

        private var _BatteryDays = "d" as String;

        private var _initialized = false as Boolean;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);
            self._hasBatteryInDays = System.getSystemStats() has :batteryInDays;
            if (Application.Properties.getValue("WidgetBatteryShowDays") == false)
            {
                self._hasBatteryInDays = false;
            }

            if (self._hasBatteryInDays == true)
            {
                self._Font = WatchUi.loadResource(Rez.Fonts.Tiny) as FontResource;
                self._BatteryDays = Application.loadResource(Rez.Strings.ShortBatteryDays) as String;
            }
            else
            {
                self._Font = WatchUi.loadResource(Rez.Fonts.Small) as FontResource;
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
            if (battery < 50.0 && battery > 30.0)
            {
                color = self._theme.BatteryIndicatorHalfColor;
            }
            else if (battery <= 30.0)
            {
                color = self._theme.BatteryIndicatorLowColor;
            }
            self._arc.draw(dc, battery, color);

            if (self._hasBatteryInDays == true)
            {
                dc.drawText(self.locX, self.locY - self._FontHeight + 2, self._Font, battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER);
                dc.drawText(self.locX, self.locY - 2, self._Font, stats.batteryInDays.format("%2d") + self._BatteryDays, Gfx.TEXT_JUSTIFY_CENTER);
            }
            else
            {
                dc.drawText(WidgetBase.locX, WidgetBase.locY - 3, self._Font, battery.format("%2d") + "%", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }            
        }

        private function Init(dc as Gfx.Dc)
        {
            //adjust position to center of widget
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = (self.locX - (self._arcRadius / 2) - (self._arcWidth / 2) - 1).toFloat();
            }
            else if (self.Justification == WIDGET_JUSTIFICATION_LEFT)
            {
                self.locX = (self.locX + self._arcRadius + (self._arcWidth / 2) + 1).toFloat();
            }   

            self.locY = (self.locY + self._arcRadius + (self._arcWidth / 2) + 1).toFloat();

            self._arc = new Helper.Gfx.DrawArc(self.locX, self.locY, self._arcRadius, self._arcWidth, self._arcStart, self._arcLength, Gfx.ARC_CLOCKWISE);
            self._arc.Parts = self._arcParts;
            self._arc.PartSeparatorWidth = self._arcPartSeparatorWidth;

            self._FontHeight = dc.getFontHeight(self._Font);
            self._initialized = true;
        }
    }
}