import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.UserProfile;
using Helper.Gfx as HGfx;
using Widgets.Indicators as Indi;

module Widgets {
    class HealthIndicator extends WidgetBase {
        private enum Indicator {
            INDICATOR_RANDOM,
            INDICATOR_HEARTRATE,
            INDICATOR_STRESS,
            INDICATOR_BREATH,
        }

        var WidgetSize = 130;

        var Texts as Array<Helper.ExtTextPart>? = null;
        var TextContainer as Helper.ExtText? = null;
        private var _iconPosX as Number = 0;
        private var _iconPosY as Number = 0;

        var _attentionIcon as BitmapResource? = null;

        var StressWarningLevel as Number = 90;
        var BreathWarningLevel as Number = 30;

        private var _indicatorPadding as Number = 10;
        private var _display as Object? = null;
        private var _showIndicator as Boolean = true;

        function initialize(params as Dictionary) {
            WidgetBase.initialize(params);

            self.WidgetSize = params.get("W");
            if (self.WidgetSize == null) {
                self.WidgetSize = 130;
            }

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                self.locX = self.locX - self.WidgetSize;
            }

            if ((Helper.Properties.Get("Deco", 1) as Number) <= 0) {
                self._showIndicator = false;
            }

            self.StressWarningLevel = Helper.Properties.Get("StressW", 90) as Number;
            if (self.StressWarningLevel <= 0 || self.StressWarningLevel > 100) {
                self.StressWarningLevel = 999;
            }
            self.BreathWarningLevel = Helper.Properties.Get("RespW", 25) as Number;
            if (self.BreathWarningLevel <= 0) {
                self.BreathWarningLevel = 999;
            }

            var iconHeight = IsSmallDisplay ? 30 : 39;
            if (HGfx.Fonts.Icons != null) {
                iconHeight = Graphics.getFontAscent(HGfx.Fonts.Icons);
            }
            var fontHeight = IsSmallDisplay ? 20 : 28;
            if (HGfx.Fonts.Small != null) {
                fontHeight = Graphics.getFontAscent(HGfx.Fonts.Small);
            }

            var indicatorPadding = IsSmallDisplay ? 8 : 12;
            var centerX;
            if (IsSmallDisplay) {
                centerX = self.locX + (self.WidgetSize / 2.2).toNumber();
            } else {
                centerX = self.locX + (self.WidgetSize / 2.4).toNumber();
            }

            if (self.Justification == Widgets.WIDGET_JUSTIFICATION_LEFT) {
                if (IsSmallDisplay) {
                    centerX += 5;
                } else {
                    centerX += 20;
                }
            }

            var textPosY = self.locY - indicatorPadding - fontHeight - 25;
            self._iconPosY = textPosY - iconHeight - 10;
            self._iconPosX = centerX;

            if (IsSmallDisplay) {
                textPosY += 8;
                self._iconPosY += 15;
            }

            self.TextContainer = new Helper.ExtText(centerX, textPosY, Graphics.TEXT_JUSTIFY_CENTER);
            $.getView().OnShow.add(self);
            $.Log("Initialized Health Widget at " + self.Justification);
        }

        function draw(dc as Dc) as Void {
            if (self._display == null) {
                self.OnShow();
            } else if ($.getView().IsBackground) {
                //update cache
                Indi.Breath.getBreath();
            }

            if (self._display != null) {
                if (self._display instanceof Indi.Heartbeat == false && Indi.Heartbeat.getHeartrate() <= 0) {
                    self.Texts = null;
                    self._display = new Indi.Heartbeat();
                }
                self._display.draw(dc, self);
            }
        }

        function OnShow() as Void {
            var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
            Indi.Heartbeat.HeartbeatZones = [zones[2], zones[3], zones[4], zones[5]];
            Indi.Heartbeat.HeartbeatMin = (zones[0] * 0.5).toNumber();

            var indicator = INDICATOR_HEARTRATE;
            var heartrate = Indi.Heartbeat.getHeartrate();

            if (heartrate > 0) {
                var stress = Indi.Stress.getStressLevel();
                var breath = Indi.Breath.getBreath();

                indicator = INDICATOR_RANDOM;
                if (heartrate >= Indi.Heartbeat.HeartbeatZones[2]) {
                    indicator = INDICATOR_HEARTRATE;
                } else {
                    if (breath >= self.BreathWarningLevel) {
                        indicator = INDICATOR_BREATH;
                    } else {
                        if (stress >= self.StressWarningLevel) {
                            indicator = INDICATOR_STRESS;
                        }
                    }
                }

                if (indicator == INDICATOR_RANDOM) {
                    indicator = self.getRandomWidget(stress, breath);
                }

                if (indicator == INDICATOR_STRESS && (self._display == null || self._display instanceof Indi.Stress == false)) {
                    self.Texts = null;
                    self._display = new Indi.Stress();
                } else if (indicator == INDICATOR_BREATH && (self._display == null || self._display instanceof Indi.Breath == false)) {
                    self.Texts = null;
                    self._display = new Indi.Breath();
                } else if (self._display == null || (indicator == INDICATOR_HEARTRATE && self._display instanceof Indi.Heartbeat == false)) {
                    self.Texts = null;
                    self._display = new Indi.Heartbeat();
                }
            }

            if (self._display == null) {
                self.Texts = null;
                self._display = new Indi.Heartbeat();
            } else if (self._display instanceof Indi.Stress && self._display has :calcColor) {
                self._display.calcColor(self);
            }
        }

        function DrawAttentionIcon(dc as Dc) as Void {
            var offsetX = IsSmallDisplay ? 3 : 5;
            var offsetY = IsSmallDisplay ? -8 : -10;

            if (self._attentionIcon == null) {
                self._attentionIcon = Application.loadResource(Rez.Drawables.Attention) as BitmapResource;
            }

            if (self._attentionIcon != null) {
                dc.drawBitmap(self._iconPosX + offsetX, self._iconPosY + offsetY, self._attentionIcon);
            }
        }

        function HideAttentionIcon() as Void {
            self._attentionIcon = null;
        }

        function DrawIcon(dc as Dc, icon as String, color as Number) as Void {
            if (HGfx.Fonts.Icons != null) {
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, icon, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }

        function DrawText(dc as Dc) as Number {
            if (self.Texts != null) {
                if (self.Texts.size() > 0) {
                    return self.TextContainer.draw(self.Texts, dc);
                }
                return 0;
            } else if (HGfx.Fonts.Normal != null) {
                dc.setColor($.getTheme().IconsOff, Graphics.COLOR_TRANSPARENT);
                dc.drawText(self.TextContainer.AnchorX, self.TextContainer.AnchorY, HGfx.Fonts.Normal, "-", Graphics.TEXT_JUSTIFY_CENTER);
                return dc.getTextWidthInPixels("-", HGfx.Fonts.Normal);
            } else {
                return 0;
            }
        }

        function drawIndicator(dc as Dc, amount as Float, color as Number) as Void {
            if (self._showIndicator == false) {
                return;
            }

            var indicatorPosX = self.locX;
            var pos = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT) {
                indicatorPosX += self.WidgetSize;
                pos = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
            }
            HGfx.DrawRoundAngle.Configure(indicatorPosX, self.locY - self.WidgetSize, self.WidgetSize, self.WidgetSize, pos);
            HGfx.DrawRoundAngle.draw(dc, amount, color);
        }

        private function getRandomWidget(s as Number, b as Number) as Indicator {
            var stress = 1;
            var breath = 1;

            if (s <= 0) {
                stress = 0;
            }

            if (b <= 0) {
                breath = 0;
            }

            var max = 1 + stress + breath;
            if (max <= 1) {
                return INDICATOR_HEARTRATE;
            }

            Math.srand(Time.now().value());
            var rdm = Math.rand() % max;
            if (rdm <= 0) {
                return INDICATOR_HEARTRATE;
            } else if (rdm == 1) {
                if (stress > 0) {
                    return INDICATOR_STRESS;
                } else {
                    return INDICATOR_BREATH;
                }
            } else {
                return INDICATOR_BREATH;
            }
        }
    }
}
