import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.ActivityMonitor;
using Toybox.Math;
using Helper.Gfx as HGfx;

module Widgets {
    class Distance extends WidgetBase {
        private var _WidgetSize = 130;
        private var _inMiles = false;
        private var _iconPosX = 0;
        private var _textPosX = 0;
        private var _textJust = Graphics.TEXT_JUSTIFY_LEFT;
        private var _showIndicator = true;
        private var _indicatorPadding = 12;

        private var _showStepsPercentage = true;

        function initialize(params as Dictionary) {
            WidgetBase.initialize(params);

            self._WidgetSize = params.get("W");
            if (self._WidgetSize == null) {
                self._WidgetSize = 130;
            }

            if (IsSmallDisplay) {
                self._indicatorPadding = 8;
            }

            self._showIndicator = (Helper.Properties.Get("Deco", 1) as Number) > 0;

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                self._iconPosX = self.locX - HGfx.DrawRoundAngle.ThicknessBold - self._indicatorPadding - 25;
                self._textPosX = self._iconPosX - 10;
                self._textJust = Graphics.TEXT_JUSTIFY_RIGHT;
            } else {
                self._iconPosX = self.locX + HGfx.DrawRoundAngle.ThicknessBold + self._indicatorPadding - 5;
                self._textPosX = self._iconPosX + (IsSmallDisplay ? 22 : 32);
                self._textJust = Graphics.TEXT_JUSTIFY_LEFT;
            }

            //show distance in miles
            self._inMiles = System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE;
            //show steps percentage
            self._showStepsPercentage = (Helper.Properties.Get("StepPer", 1) as Number) > 0;
        }

        function draw(dc as Dc) as Void {
            var info = ActivityMonitor.getInfo();

            //for screenshots :)
            /*info.calories = 2586;
            info.distance = 1187000;
            info.steps = 5687;
            info.stepGoal = 6500;*/

            var lineHeight = IsSmallDisplay ? 22 : 33;
            var drawYpos = self.locY - self._indicatorPadding - lineHeight - 3;
            if (!IsSmallDisplay) {
                drawYpos -= 3;
            }

            self.drawSteps(dc, info, drawYpos);
            drawYpos -= lineHeight;
            self.drawDistance(dc, info, drawYpos);
            drawYpos -= lineHeight;
            self.drawCalories(dc, info, drawYpos);

            if (self._showIndicator) {
                self.drawStepsIndicator(dc, info);
            }
        }

        private function drawCalories(dc as Dc, info as ActivityMonitor.Info?, drawYpos as Number) as Void {
            //icon
            if (HGfx.Fonts.Icons != null) {
                if (Themes.Colors.IconsInTextColor == true) {
                    dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                } else {
                    dc.setColor($.getTheme().DistanceCaloriesColor, Graphics.COLOR_TRANSPARENT);
                }

                var offset = IsSmallDisplay ? 0 : -4;
                dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, HGfx.ICONS_CALORIES, Graphics.TEXT_JUSTIFY_LEFT);
            }
            //text
            if (HGfx.Fonts.Small != null) {
                dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                var text = "-";
                if (info != null && info.calories != null) {
                    text = info.calories.toString();
                }
                dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, text, self._textJust);
            }
        }

        private function drawDistance(dc as Dc, info as ActivityMonitor.Info?, drawYpos as Number) as Void {
            //Icon
            if (HGfx.Fonts.Icons != null) {
                if (Themes.Colors.IconsInTextColor == true) {
                    dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                } else {
                    dc.setColor($.getTheme().DistanceIconColor, Graphics.COLOR_TRANSPARENT);
                }

                var offset = IsSmallDisplay ? 2 : 0;
                dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, HGfx.ICONS_DISTANCE, Graphics.TEXT_JUSTIFY_LEFT);
            }
            //text
            if (HGfx.Fonts.Small != null) {
                var text = "-";
                if (info != null && info.distance != null) {
                    if (self._inMiles == true) {
                        text = self.FormatMiles(info.distance);
                    } else {
                        text = self.FormatMeters(info.distance);
                    }
                }
                dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, text, self._textJust);
            }
        }

        private function drawSteps(dc as Dc, info as ActivityMonitor.Info?, drawYpos as Number) as Void {
            //icon
            if (HGfx.Fonts.Icons != null) {
                if (Themes.Colors.IconsInTextColor == true) {
                    dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                } else {
                    dc.setColor($.getTheme().DistanceStepsIconColor, Graphics.COLOR_TRANSPARENT);
                }

                var offset = IsSmallDisplay ? 4 : 2;
                dc.drawText(self._iconPosX, drawYpos + offset, HGfx.Fonts.Icons, HGfx.ICONS_STEPS, Graphics.TEXT_JUSTIFY_LEFT);
            }

            //text
            if (HGfx.Fonts.Small != null) {
                dc.setColor(Themes.Colors.Text2, Graphics.COLOR_TRANSPARENT);
                if (info != null && info.steps != null) {
                    var yOffset = IsSmallDisplay ? 3 : 6;
                    var width = dc.getTextWidthInPixels(info.steps.toString(), HGfx.Fonts.Small);
                    var percent_width = 0;
                    if (self._showStepsPercentage == true && info.stepGoal != null) {
                        var amount = info.steps.toFloat() / info.stepGoal.toFloat(); //WIP: Check if stepsGloal ios set
                        if (self._textJust == Graphics.TEXT_JUSTIFY_LEFT) {
                            if (amount >= 1.0 && HGfx.Fonts.Icons != null) {
                                if (IsSmallDisplay) {
                                    dc.drawText(self._textPosX + width + 3, drawYpos + 4, HGfx.Fonts.Icons, HGfx.ICONS_CHECKMARK, self._textJust);
                                } else {
                                    dc.drawText(self._textPosX + width + 5, drawYpos + yOffset, HGfx.Fonts.Icons, HGfx.ICONS_CHECKMARK, self._textJust);
                                }
                            } else if (amount < 1.0 && HGfx.Fonts.Tiny != null) {
                                var percent = "(" + (amount * 100).toNumber().toString() + "%)";
                                dc.drawText(self._textPosX + width + 5, drawYpos + yOffset, HGfx.Fonts.Tiny, percent, self._textJust);
                            }
                        } else {
                            if (amount >= 1.0 && HGfx.Fonts.Icons != null) {
                                var textwidth = dc.getTextWidthInPixels(info.steps.toString(), HGfx.Fonts.Small) + 5;
                                dc.drawText(self._textPosX - textwidth, drawYpos + 6, HGfx.Fonts.Icons, HGfx.ICONS_CHECKMARK, self._textJust);
                            } else if (amount < 1.0 && HGfx.Fonts.Tiny != null) {
                                var percent = "(" + (amount * 100).toNumber().toString() + "%)";
                                dc.drawText(self._textPosX, drawYpos + 6, HGfx.Fonts.Tiny, percent, self._textJust);
                                percent_width = dc.getTextWidthInPixels(percent, HGfx.Fonts.Tiny) + 5;
                            }
                        }
                    }
                    dc.drawText(self._textPosX - percent_width, drawYpos + 3, HGfx.Fonts.Small, info.steps, self._textJust);
                } else {
                    dc.drawText(self._textPosX, drawYpos + 3, HGfx.Fonts.Small, "-", self._textJust);
                }
            }
        }

        private function drawStepsIndicator(dc as Dc, info as ActivityMonitor.Info?) as Void {
            var amount = 0.0;
            if (info != null && info.steps != null && info.stepGoal != null) {
                amount = info.steps.toFloat() / info.stepGoal.toFloat();
            }

            var pos = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                pos = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
            }
            var colors = $.getTheme().IndicatorSteps;
            var factor = 1.0 / colors.size().toFloat();
            var color = colors[0];

            HGfx.DrawRoundAngle.Configure(self.locX, self.locY - self._WidgetSize, self._WidgetSize, self._WidgetSize, pos);
            if (amount > 0) {
                var a = 1.0;
                for (var i = 0; i < colors.size(); i++) {
                    if (a >= amount) {
                        color = colors[i];
                    } else {
                        break;
                    }
                    a -= factor;
                }
            }
            HGfx.DrawRoundAngle.draw(dc, amount, color);
        }

        private function FormatMiles(centimeters as Number) as String {
            var dist = centimeters.toFloat() * 0.0328084; //feet
            if (dist >= 5280.0) {
                dist = dist / 5280.0; //miles
                if (dist >= 100.0) {
                    return Math.round(dist).toNumber() + " mi"; //only show full miles
                }

                return dist.format("%.2f") + " mi";
            } else {
                return Math.round(dist).toNumber() + " ft";
            }
        }

        private function FormatMeters(centimeters as Number) as String {
            var dist = centimeters.toFloat() / 100.0; //meters
            if (dist >= 1000.0) {
                dist = dist / 1000.0;
                if (dist >= 100.0) {
                    return Math.round(dist).toNumber() + " km";
                }
                return Helper.String.stringReplace(dist.format("%.2f"), ".", ",") + " km";
            } else {
                return Math.round(dist).toNumber() + " m";
            }
        }
    }
}
