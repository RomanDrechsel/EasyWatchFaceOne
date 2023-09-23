import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile;
using Helper.Gfx as HGfx;
using Widgets.Indicators as Indi;

module Widgets 
{
    class HealthIndicator extends WidgetBase
    {
        private enum Indicator { INDICATOR_RANDOM, INDICATOR_HEARTRATE, INDICATOR_STRESS, INDICATOR_BREATH }

        var WidgetSize = 150;
       
        private var _indicatorPadding = 10;
        private var _display = null as Indi.IndicatorBase;
        private var _showIndicator = true;
        
        var _attentionIcon = null as BitmapResource;

        var StressWarningLevel = 90.0;
        var BreathWarningLevel = 30;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self.WidgetSize = params.get("W");
            if (self.WidgetSize == null)
            {
                self.WidgetSize = 130;
            }

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = self.locX - self.WidgetSize;
            }

            var show = Application.Properties.getValue("Deco") as Number;
            if (show != null && show <= 0)
            {
                self._showIndicator = false;
            }

            self.StressWarningLevel = Application.Properties.getValue("StressW") as Float;
            self.BreathWarningLevel = Application.Properties.getValue("RespW") as Number;

            $.getView().OnWakeUp.add(self);
        }

        function draw(dc as Gfx.Dc)
        {
            if (self._display == null)
            {
                self.OnWakeUp();
            }

            if (self._display != null)
            {
                self._display.draw(dc, self);
            }
        }

        function OnWakeUp()
        {
            var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
            Indi.Heartbeat.HeartbeatZones = [ zones[2], zones[3], zones[4], zones[5] ];
            Indi.Heartbeat.HeartbeatMin = zones[0] * 0.6;

            var indicator = INDICATOR_HEARTRATE;
            var heartrate = Indi.Heartbeat.getHeartrate();

            if (heartrate > 0)
            {
                var stress = Indi.Stress.getStressLevel();
                var breath = Indi.Breath.getBreath();

                indicator = INDICATOR_RANDOM;
                if (heartrate >= Indi.Heartbeat.HeartbeatZones[2])
                {
                    indicator = INDICATOR_HEARTRATE;
                }
                else 
                {                    
                    if (breath >= self.BreathWarningLevel)
                    {
                        indicator = INDICATOR_BREATH;
                    }
                    else 
                    {
                        if (stress >= self.StressWarningLevel)
                        {
                            indicator = INDICATOR_STRESS;
                        }
                    }
                }

                if (indicator == INDICATOR_RANDOM)
                {
                    indicator = self.getRandomWidget(stress, breath);
                }

                if (indicator == INDICATOR_STRESS && (self._display == null || self._display instanceof Indi.Stress == false))
                {
                    self._display = new Indi.Stress();
                }
                else if (indicator == INDICATOR_BREATH && (self._display == null || self._display instanceof Indi.Breath == false))
                {
                    self._display = new Indi.Breath();
                }
                else if (self._display == null || (indicator == INDICATOR_HEARTRATE && self._display instanceof Indi.Heartbeat == false))
                {
                    self._display = new  Indi.Heartbeat();
                }
            }

            if (self._display == null)
            {
                self._display = new Indi.Heartbeat();
            }
        }

        private function getRandomWidget(s as Float, b as Number) as Indicator
        {
            var stress = 1;
            var breath = 1;
            
            if (s <= 0.0)
            {
                stress = 0;
            }

            if (b <= 0)
            {
                breath = 0;
            }

            var max = 1 + stress + breath;
            if (max <= 1)
            {
                return INDICATOR_HEARTRATE;
            }

            var rdm = Helper.MathHelper.RandomInRange(0, max);
            if (stress > 0 && rdm > 1)
            {
                return INDICATOR_STRESS;
            }
            else if (breath > 0 && rdm > 0)
            {
                return INDICATOR_BREATH;
            }
            else
            {
                return INDICATOR_HEARTRATE;
            }
        }

        function DrawAttentionIcon(dc as Gfx.Dc, ix as Number, iy as Number)
        {
            dc.drawBitmap(ix + 10, iy - 25, self.GetAttentionIcon());
        }

        function HideAttentionIcon()
        {
            self._attentionIcon = null;
        }

        function drawIndicator(dc as Gfx.Dc, amount as Float, color as Number) as Void
        {
            if (self._showIndicator == false)
            {
                return;
            }

            var indicatorPosX = self.locX;
            var pos = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                indicatorPosX += self.WidgetSize;
                pos = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
            }
            HGfx.DrawRoundAngle.Configure(indicatorPosX, self.locY - self.WidgetSize, self.WidgetSize, self.WidgetSize, pos);
            HGfx.DrawRoundAngle.draw(dc, 0, 0);
            HGfx.DrawRoundAngle.draw(dc, amount, color);
        }

        private function GetAttentionIcon() as BitmapResource
        {
            if (self._attentionIcon == null)
            {
                self._attentionIcon = Application.loadResource(Rez.Drawables.Attention) as BitmapResource;
            }

            return self._attentionIcon;
        }
    }
}
