using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.ActivityMonitor;
using Toybox.Math;
using Helper.Gfx as Draw;

module Widgets
{
    class Distance extends WidgetBase
    {
        private var _Icons = null as FontResource;
        private var _Font = null as FontResource;

        private var _WidgetHeight as Number;
        private var _WidgetWidth = 150 as Number;
        private var _inMiles = false as Boolean;
        private var _drawYpos as Number;
        private var _lineHeight = 33 as Number;
        private var _iconXpos = self.locX as Number;

        private var _indicatorLineWidth = 6;
        private var _indicatorLineWidthBold = 8;
        private var _indicatorPadding = 8;
        private var _indicatorDrawing = null as Draw.DrawRoundAngle;

        private const CENTIMETER_TO_FEET = 0.0328084 as Float;
        private const FEET_TO_MILES = 5280.0 as Float;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._Icons = WatchUi.loadResource(Rez.Fonts.Icons) as FontResource;
            self._Font = WatchUi.loadResource(Rez.Fonts.Small) as FontResource;

            self._WidgetHeight = (self._lineHeight * 3) + self._indicatorLineWidthBold + self._indicatorPadding;

            if (params[:Width] != null)
            {
                self._WidgetWidth = params[:Width];
            }

            if (self.VJustification == WIDGET_JUSTIFICATION_BOTTOM)
            {
                self.locY = self.locY - self._WidgetHeight;
            }
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = self.locX - self._WidgetWidth;   
            }

            self._indicatorDrawing = new Draw.DrawRoundAngle(self.locX, self.locY, self._WidgetWidth, self._WidgetHeight + self._indicatorPadding + (self._lineHeight / 2), self._WidgetHeight / 4);
            self._indicatorDrawing.BackgroundColor = self._theme.DistanceIndicatorBackground;
            self._indicatorDrawing.BarColor = self._theme.DistanceIndicatorForeground;
            self._indicatorDrawing.Thickness = self._indicatorLineWidth;
            self._indicatorDrawing.ThicknessBold = self._indicatorLineWidthBold;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self._indicatorDrawing.Direction = Gfx.ARC_CLOCKWISE;
            }

            //Show distane in miles
            if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE)
            {
                self._inMiles = true;
            }

            self._iconXpos = self.locX + self._indicatorLineWidthBold + self._indicatorPadding;
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            var info = ActivityMonitor.getInfo();

            dc.setColor(self._theme.DistanceColor, Gfx.COLOR_TRANSPARENT);

            self._drawYpos = self.locY;

            self.drawCalories(dc, info);
            self.drawDistance(dc, info);
            self.drawSteps(dc, info);
            self.drawStepsIndicator(dc, info);
        }

        private function drawCalories(dc as Gfx.Dc, info as ActivityMonitor.Info)
        {
            dc.drawText(self._iconXpos, self._drawYpos, self._Icons, Helper.Gfx.ICONS_CALORIES, Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(self._iconXpos + 35, self._drawYpos + 3, self._Font, info.calories.toString(), Gfx.TEXT_JUSTIFY_LEFT);

            self._drawYpos += self._lineHeight;
        }

        private function drawDistance(dc as Gfx.Dc, info as ActivityMonitor.Info)
        {
            var str = "";
            if (self._inMiles == true)
            {
                str = self.FormatMiles(info.distance);
            }
            else
            {
                str = self.FormatMeters(info.distance);
            }
            dc.drawText(self._iconXpos, self._drawYpos, self._Icons, Helper.Gfx.ICONS_DISTANCE, Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(self._iconXpos + 35, self._drawYpos + 3, self._Font, str, Gfx.TEXT_JUSTIFY_LEFT);

            self._drawYpos += self._lineHeight;
        }

        private function drawSteps(dc as Gfx.Dc, info as ActivityMonitor.Info)
        {
            dc.drawText(self._iconXpos, self._drawYpos, self._Icons, Helper.Gfx.ICONS_STEPS, Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(self._iconXpos + 35, self._drawYpos + 3, self._Font, info.steps, Gfx.TEXT_JUSTIFY_LEFT);

            self._drawYpos += self._lineHeight;
        }

        private function drawStepsIndicator(dc as Gfx.Dc, info as ActivityMonitor.Info)
        {
            self._indicatorDrawing.draw(dc, info.steps.toFloat() / info.stepGoal.toFloat());
        }

        private function FormatMiles(centimeters as Number) as String
        {
            var dist = centimeters * self.CENTIMETER_TO_FEET as Float; //feet
            if (dist >= self.FEET_TO_MILES)
            {
                dist = dist / self.FEET_TO_MILES as Float;
                if (dist >= 100)
                {
                    return Math.round(dist).toNumber() + " mi"; //only show full miles
                }

                return dist.format("%.2f") + " mi"; 
            }
            else
            {
                return Math.round(dist).toNumber().toString() + " ft";
            }
        }

        private function FormatMeters(centimeters as Number) as String
        {
            var dist = centimeters / 100; //meters
            if (dist >= 1000)
            {
                dist = dist / 1000.0 as Float;
                if (dist >= 100)
                {
                    return Math.round(dist).toNumber() + " km";
                }
                return Helper.String.stringReplace(dist.format("%.2f"), ".", ",") + " km"; 
            }
            else
            {
                return Math.round(dist).toNumber().toString() + " m";
            }
        }
    }
}