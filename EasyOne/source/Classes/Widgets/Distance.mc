import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor;
using Toybox.Math;
using Helper.Gfx as HGfx;

module Widgets
{
    class Distance extends WidgetBase
    {
        private var _WidgetSize = 130;
        private var _inMiles = false as Boolean;
        private var _startdrawYpos as Number;
        private var _lineHeight = 33;
        private var _iconPosX = self.locX;
        private var _textPosX = self.locX;
        private var _textJust = Gfx.TEXT_JUSTIFY_LEFT;
        private var _showIndicator = true;

        private var _showStepsPercentage = true;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._WidgetSize = params.get("W");
            if (self._WidgetSize == null)
            {
                self._WidgetSize = 130;
            }

            var indicatorPadding = 12;
            if (IsSmallDisplay)
            {
                indicatorPadding = 8;
                self._lineHeight = 22;
            }
            
            self._startdrawYpos = self.locY - indicatorPadding - self._lineHeight;

            var show = Application.Properties.getValue("Deco") as Number;
            if (show != null && show <= 0)
            {
                self._showIndicator = false;
            }

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self._iconPosX = self.locX - HGfx.DrawRoundAngle.ThicknessBold - indicatorPadding - 25;
                self._textPosX = self._iconPosX - 10;
                self._textJust = Gfx.TEXT_JUSTIFY_RIGHT;
            }
            else
            {
                self._iconPosX = self.locX + HGfx.DrawRoundAngle.ThicknessBold + indicatorPadding;
                if (!IsSmallDisplay)
                {
                    self._textPosX = self._iconPosX + 35;
                }
                else
                {
                    self._textPosX = self._iconPosX + 22;
                }
                self._textJust = Gfx.TEXT_JUSTIFY_LEFT;
            }

            //Show distane in miles
            if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE)
            {
                self._inMiles = true;
            }
            else
            {
                self._inMiles = false;
            }

            var setting = Application.Properties.getValue("StepPer") as Number;
            if (setting != null && setting <= 0)
            {
                self._showStepsPercentage = false;
            }
            else
            {
                self._showStepsPercentage = true;
            }
        }

        function draw(dc as Gfx.Dc) as Void 
        {
            var info = ActivityMonitor.getInfo();

            //for screenshots :)
            /*info.calories = 2586;
            info.distance = 1187000;
            info.steps = 5687;
            info.stepGoal = 6500;*/

            var drawYpos = self._startdrawYpos;

            self.drawSteps(dc, info, drawYpos);
            drawYpos -= self._lineHeight;
            self.drawDistance(dc, info, drawYpos);
            drawYpos -= self._lineHeight;
            self.drawCalories(dc, info, drawYpos);
            
            if (self._showIndicator)
            {
                self.drawStepsIndicator(dc, info);
            }
        }

        private function drawCalories(dc as Gfx.Dc, info as ActivityMonitor.Info, drawYpos as Number) as Void
        {
            if (Themes.Colors.IconsInTextColor == true)
            {
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
            }
            else
            {
                dc.setColor($.getTheme().DistanceCaloriesColor, Gfx.COLOR_TRANSPARENT);
            }

            var offset = -4;
            if (IsSmallDisplay)
            {
                offset = 0;
            }
            dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, HGfx.ICONS_CALORIES, Gfx.TEXT_JUSTIFY_LEFT);
            if (info != null)
            {
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, info.calories.toString(), self._textJust);
            }
        }

        private function drawDistance(dc as Gfx.Dc, info as ActivityMonitor.Info, drawYpos as Number) as Void
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

            if (Themes.Colors.IconsInTextColor == true)
            {
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
            }
            else
            {
                dc.setColor($.getTheme().DistanceIconColor, Gfx.COLOR_TRANSPARENT);
            }

            var offset = 0;
            if (IsSmallDisplay)
            {
                offset = 2;
            }
            dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, Helper.Gfx.ICONS_DISTANCE, Gfx.TEXT_JUSTIFY_LEFT);
            if (info != null)
            {
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
                dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, str, self._textJust);
            }
        }

        private function drawSteps(dc as Gfx.Dc, info as ActivityMonitor.Info, drawYpos as Number) as Void
        {
            if (Themes.Colors.IconsInTextColor == true)
            {
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
            }
            else
            {
                dc.setColor($.getTheme().DistanceStepsIconColor, Gfx.COLOR_TRANSPARENT);
            }

            var offset = 2;
            if (IsSmallDisplay)
            {
                offset = 4;
            }
            dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, Helper.Gfx.ICONS_STEPS, Gfx.TEXT_JUSTIFY_LEFT);
            if (info != null)
            {
                var amount = info.steps.toFloat() / info.stepGoal.toFloat();
                dc.setColor(Themes.Colors.Text2, Gfx.COLOR_TRANSPARENT);
                if (self._textJust == Gfx.TEXT_JUSTIFY_LEFT)
                {   
                    var yOffset;
                    if (IsSmallDisplay)
                    {
                        yOffset = 3;
                    }
                    else
                    {
                        yOffset = 6;
                    }

                    var width = dc.getTextWidthInPixels(info.steps.toString(), HGfx.Fonts.Small);                 
                    dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, info.steps, self._textJust);
                    if (self._showStepsPercentage == true)
                    {
                        if (amount >= 1.0)
                        {
                            if (IsSmallDisplay)
                            {
                                dc.drawText(self._textPosX + width + 3, drawYpos + 4, HGfx.Fonts.Icons, Helper.Gfx.ICONS_CHECKMARK, self._textJust);
                            }
                            else
                            {
                                dc.drawText(self._textPosX + width + 5, drawYpos + yOffset, HGfx.Fonts.Icons, Helper.Gfx.ICONS_CHECKMARK, self._textJust);
                            }
                        }
                        else
                        {
                            var percent = "(" + (amount * 100).toNumber().toString() + "%)";
                            dc.drawText(self._textPosX + width + 5, drawYpos + yOffset, HGfx.Fonts.Tiny, percent, self._textJust);
                        }
                    }
                }
                else
                {
                    if (amount >= 1.0)
                    {                               
                        dc.drawText(self._textPosX , drawYpos + 3, HGfx.Fonts.Small, info.steps, self._textJust);
                        if (self._showStepsPercentage == true)
                        {
                            var textwidth = dc.getTextWidthInPixels(info.steps.toString(), HGfx.Fonts.Small) + 5; 
                            dc.drawText(self._textPosX - textwidth, drawYpos + 6, HGfx.Fonts.Icons, Helper.Gfx.ICONS_CHECKMARK, self._textJust);
                        }
                    }
                    else
                    {
                        var percent_width = 0;
                        if (self._showStepsPercentage == true)
                        {
                            var percent = "(" + (amount * 100).toNumber().toString() + "%)";                            
                            dc.drawText(self._textPosX, drawYpos + 6, HGfx.Fonts.Tiny, percent, self._textJust);
                            percent_width = dc.getTextWidthInPixels(percent, HGfx.Fonts.Tiny) + 5;
                        }
                        dc.drawText(self._textPosX - percent_width, drawYpos + 3, HGfx.Fonts.Small, info.steps, self._textJust);
                    }                    
                }
            }
        }

        private function drawStepsIndicator(dc as Gfx.Dc, info as ActivityMonitor.Info) as Void
        {
            var amount = 0.0;
            if (info != null)
            {
                amount = info.steps.toFloat() / info.stepGoal.toFloat();
            }

            var pos = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                pos = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
            }
            HGfx.DrawRoundAngle.Configure(self.locX, self.locY - self._WidgetSize, self._WidgetSize, self._WidgetSize, pos);

            HGfx.DrawRoundAngle.draw(dc, 0, 0);
            if (amount > 0)
            {
                var colors = $.getTheme().IndicatorSteps;
                var factor = 1.0 / colors.size().toFloat();
                var color = colors[0];
                var a = 1.0;

                for (var i = 0; i < colors.size(); i++)
                {
                    if (a >= amount)
                    {
                        color = colors[i];
                    }
                    else
                    {
                        break;
                    }
                    a -= factor;
                }
                HGfx.DrawRoundAngle.draw(dc, amount, color);
            }            
        }

        private function FormatMiles(centimeters as Number) as String
        {
            var dist = centimeters.toFloat() * 0.0328084; //feet
            if (dist >= 5280.0)
            {
                dist = dist / 5280.0; //miles
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
            var dist = centimeters.toFloat() / 100.0; //meters
            if (dist >= 1000.0)
            {
                dist = dist / 1000.0;
                if (dist >= 100.0)
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