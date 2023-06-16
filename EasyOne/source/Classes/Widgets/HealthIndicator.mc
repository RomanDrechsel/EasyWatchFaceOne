using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.UserProfile;
using Helper.Gfx as HGfx;
using Widgets.Indicators as Indi;

module Widgets 
{
    class HealthIndicator extends WidgetBase
    {
        private enum Indicator { INDICATOR_RANDOM, INDICATOR_HEARTRATE, INDICATOR_STRESS, INDICATOR_BREATH }

        var WidgetHeight = 200;
        var WidgetWidth = 150;
       
        private var _indicatorPadding = 10;
        private var _display = null as Indi.IndicatorBase;
        
        var _attentionIcon = null as BitmapResource;
        var IndicatorDrawing = null as HGfx.DrawRoundAngle;
        var IndicatorColors  = [] as Array<Number>;

        var StressWarningLevel = 90.0;
        var BreathWarningLevel = 30;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            if (params[:Width] != null)
            {
                self.WidgetWidth = params[:Width];
            }

            if (params[:Height] != null)
            {
                self.WidgetHeight = params[:Height];
            }

            var indicatorPosX = self.locX;
            self.locY = self.locY - self.WidgetHeight;
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                indicatorPosX = self.locX;
                self.locX = self.locX - self.WidgetWidth;
            }

            self.IndicatorColors = [
                self._theme.IndicatorLevel1,
                self._theme.IndicatorLevel3,
                self._theme.IndicatorLevel4,
                self._theme.IndicatorLevel5,
            ];

            self.IndicatorDrawing = new HGfx.DrawRoundAngle(indicatorPosX, self.locY, self.WidgetWidth, self.WidgetHeight, self.WidgetHeight / 4);

            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.IndicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMRIGHT;
                
            }
            else
            {
                self.IndicatorDrawing.Direction = HGfx.DrawRoundAngle.JUST_BOTTOMLEFT;
            }

            var show = Application.Properties.getValue("ShowDecolines") as Number;
            if (show != null && show <= 0)
            {
                self.IndicatorDrawing.BackgroundColor = Gfx.COLOR_TRANSPARENT;
            }

            $.getView().OnWakeUp.add(self.method(:OnWakeUp));
            $.getView().OnSleep.add(self.method(:OnSleep));

            self.StressWarningLevel = Application.Properties.getValue("StressWarningLevel") as Float;
            self.BreathWarningLevel = Application.Properties.getValue("WarningRespirationRate") as Number;
        }

        function draw(dc as Gfx.Dc)
        {
            if (self._display == null)
            {
                self.OnWakeUp();
            }

            self._display.draw(dc);
        }

        function OnSleep()
        {
            $.getView().OnUpdate.add(self.method(:OnBackgroundUpdate));
        }

        function OnWakeUp()
        {
            $.getView().OnUpdate.remove(self.method(:OnBackgroundUpdate));
            var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
            Indi.Heartbeat.HeartbeatZones = [ zones[2], zones[3], zones[4], zones[5] ];
            Indi.Heartbeat.HeartbeatMin = zones[0] * 0.6;

            var indicator = INDICATOR_HEARTRATE;
            var heartrate = Indi.Heartbeat.getHeartrate();
            var stress = Indi.Stress.getStressLevel();
            var breath = Indi.Breath.getBreath();

            if (heartrate > 0)
            {
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
            }

            if (indicator == INDICATOR_RANDOM)
            {
                indicator = self.getRandomWidget(stress, breath);
            }

            if (indicator == INDICATOR_STRESS && (self._display == null || self._display instanceof Indi.Stress == false))
            {
                self._display = new Indi.Stress(self);
            }
            else if (indicator == INDICATOR_BREATH && (self._display == null || self._display instanceof Indi.Breath == false))
            {
                self._display = new Indi.Breath(self);
            }
            else if (self._display == null || (indicator == INDICATOR_HEARTRATE && self._display instanceof Indi.Heartbeat == false))
            {
                self._display = new  Indi.Heartbeat(self);
            }
        }

        function OnBackgroundUpdate()
        {
            //Update breath cache every 60sec in background
            Indi.Breath.getBreath();
        }

        private function getRandomWidget(s as Float, b as Number) as Indicator
        {
            var heartrate = 1;
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

            var max = heartrate + stress + breath;
            if (max <= 0)
            {
                return INDICATOR_HEARTRATE;
            }

            var rdm = Helper.MathHelper.RandomInRange(0, max);

            if (heartrate > 0 && rdm < heartrate)
            {
                return INDICATOR_HEARTRATE;
            }
            else if (stress > 0 && rdm < heartrate + stress)
            {
                return INDICATOR_STRESS;
            }
            else
            {
                return INDICATOR_BREATH;
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