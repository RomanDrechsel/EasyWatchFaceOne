import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Helper.Gfx as HGfx;

module Widgets {
    class BatteryStatus extends WidgetBase {
        private var _BatteryDaysText as String? = null;
        private var _BatteryDisplay = 1;
        private var _arcRadius = 35;
        private var _arcWidth = 9;

        function initialize(params as Dictionary) {
            WidgetBase.initialize(params);

            if (IsSmallDisplay) {
                self._arcRadius = 25;
                self._arcWidth = 6;
            }

            var settings = Helper.Properties.Get("Bat", -1) as Number;
            var max_settings = IsSmallDisplay ? 1 : 3;
            if (settings < 0 || settings > max_settings) {
                self._BatteryDisplay = IsSmallDisplay ? 1 : 3;
            } else {
                self._BatteryDisplay = settings;
            }

            if (self._BatteryDisplay >= 2 && Rez.Strings has :ShortBatteryDays) {
                self._BatteryDaysText = Application.loadResource(Rez.Strings.ShortBatteryDays) as String;
            } else {
                self._BatteryDaysText = null;
            }

            //adjust position to center of widget
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                self.locX = self.locX - (self._arcRadius / 2).toNumber() - (self._arcWidth / 2).toNumber() - 8;
            } else if (self.Justification == WIDGET_JUSTIFICATION_LEFT) {
                self.locX = self.locX + self._arcRadius + (self._arcWidth / 2).toNumber() + 3;
            }

            self.locY = self.locY + self._arcRadius + (self._arcWidth / 2).toNumber() + 3;
        }

        function draw(dc as Dc) as Void {
            var theme = $.getTheme();

            //Background
            dc.setColor(theme.BatteryIndicatorBackgroundColor, Graphics.COLOR_TRANSPARENT);
            self.drawArc(dc, 100.0);

            //colored battery status
            var stats = System.getSystemStats();
            var color = theme.BatteryIndicatorFullColor;

            if (stats.battery < 20.0) {
                color = theme.BatteryIndicatorLowColor;
            } else if (stats.battery < 40.0) {
                color = theme.BatteryIndicatorHalfColor;
            }

            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            self.drawArc(dc, stats.battery);

            if (self._BatteryDisplay == 3 && self._BatteryDaysText != null && stats has :batteryInDays) {
                if (HGfx.Fonts.Tiny != null) {
                    dc.drawText(self.locX, self.locY - dc.getFontHeight(HGfx.Fonts.Tiny), HGfx.Fonts.Tiny, stats.battery.format("%2d") + "%", Graphics.TEXT_JUSTIFY_CENTER);
                    dc.drawText(self.locX, self.locY - 2, HGfx.Fonts.Tiny, stats.batteryInDays.format("%2d") + self._BatteryDaysText, Graphics.TEXT_JUSTIFY_CENTER);
                }
            } else if (HGfx.Fonts.Small != null) {
                var txt = null;
                if (self._BatteryDisplay == 1 || (IsSmallDisplay && self._BatteryDisplay > 1)) {
                    txt = stats.battery.format("%2d") + "%";
                } else if (self._BatteryDisplay == 2 && self._BatteryDaysText != null && stats has :batteryInDays) {
                    txt = stats.batteryInDays.format("%2d") + self._BatteryDaysText;
                }

                if (txt != null) {
                    dc.drawText(self.locX, self.locY - 3, HGfx.Fonts.Small, txt, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                }
            }
        }

        private function drawArc(dc as Dc, percent as Float) as Void {
            var arcLength = 230.0;
            var arcParts = 6;

            var arcStart = 220.0;
            var arcFactor = 1.0;
            var arcDirection = Graphics.ARC_CLOCKWISE;
            var arcPartSeparatorWidth = 5;

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                arcFactor = -1.0;
                arcDirection = Graphics.ARC_COUNTER_CLOCKWISE;
                arcStart = -40.0;
            }

            var length = (arcLength * percent).toFloat() / 100.0;
            var end = arcStart - length * arcFactor;

            dc.setPenWidth(self._arcWidth);
            var deg = arcStart;
            var partdeg = arcLength / arcParts;
            partdeg -= arcPartSeparatorWidth;

            for (var i = 0; i < arcParts; i++) {
                var partend = deg - partdeg * arcFactor;
                if (i == arcParts - 1) {
                    partend -= arcPartSeparatorWidth * arcFactor;
                }
                if (arcDirection == Graphics.ARC_COUNTER_CLOCKWISE) {
                    if (partend > end) {
                        partend = end;
                    }
                } else {
                    if (partend < end) {
                        partend = end;
                    }
                }

                if (deg.toNumber() == partend.toNumber()) {
                    continue;
                }

                dc.drawArc(self.locX, self.locY, self._arcRadius, arcDirection, deg, partend);
                deg -= (partdeg + arcPartSeparatorWidth) * arcFactor;
                if (arcDirection == Graphics.ARC_COUNTER_CLOCKWISE) {
                    if (deg >= end) {
                        break;
                    }
                } else {
                    if (deg <= end) {
                        break;
                    }
                }
            }
        }
    }
}
