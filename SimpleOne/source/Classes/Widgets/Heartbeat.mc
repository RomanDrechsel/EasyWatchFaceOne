using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.UserProfile;
using Helper.Gfx as Draw;
using Widgets.Indicators as Indi;

module Widgets 
{
    class Heartbeat extends WidgetBase
    {
        var _WidgetHeight = 200;
        var _WidgetWidth = 150;

        var _Icons as FontResource;
        var _Font as FontResource;
        var _Font2 as FontResource;
       
        private var _indicatorLineWidth = 4;
        private var _indicatorLineWidthBold = 5;
        private var _indicatorDotRadius = 5;
        private var _indicatorPadding = 10;
        var _indicatorDrawing = null as Draw.DrawRoundAngle;

        private var _display = null as Indi.IndicatorBase;

        var _heartbeatZones = [];
        var _heartbeatMin = 0;

        function initialize(params as Dictionary) 
        {
            WidgetBase.initialize(params);

            self._Icons = WatchUi.loadResource(Rez.Fonts.Icons) as FontResource;
            self._Font = WatchUi.loadResource(Rez.Fonts.Normal) as FontResource;
            self._Font2 = WatchUi.loadResource(Rez.Fonts.Small) as FontResource;

            if (params[:Width] != null)
            {
                self._WidgetWidth = params[:Width];
            }

            if (params[:Height] != null)
            {
                self._WidgetHeight = params[:Height];
            }

            if (self.VJustification == WIDGET_JUSTIFICATION_BOTTOM)
            {
                self.locY = self.locY - self._WidgetHeight;
            }
            if (self.Justification == WIDGET_JUSTIFICATION_RIGHT)
            {
                self.locX = self.locX - self._WidgetWidth;   
            }

            self._indicatorDrawing = new Draw.DrawRoundAngle(self.locX + self._WidgetWidth, self.locY, self._WidgetWidth, self._WidgetHeight, self._WidgetHeight / 4);
            self._indicatorDrawing.BackgroundColor = self._theme.IndicatorBackground;
            self._indicatorDrawing.Thickness = self._indicatorLineWidth;
            self._indicatorDrawing.ThicknessBold = self._indicatorLineWidthBold;
            self._indicatorDrawing.DotRadius = self._indicatorDotRadius;
            self._indicatorDrawing.Direction = Draw.DrawRoundAngle.JUST_BOTTOMRIGHT;
            $.getView().AddWakeUp(self.method(:OnWakeUp));
        }

        function draw(dc as Gfx.Dc)
        {
            if (self._display == null)
            {
                self.OnWakeUp();
            }
            self._display.draw(dc);
        }

        function OnWakeUp()
        {
            var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
            self._heartbeatZones = [ zones[2], zones[3], zones[4], zones[5] ];
            self._heartbeatMin = zones[0] * 0.6;

            var heartrate = Indi.Heartbeat.getHeartrate();
            
            var stress = Indi.Stress.getStressLevel();
            var stresswarninglevel = Application.Properties.getValue("StressWarningLevel") as Float;

            var found = false;
            if (heartrate > 0)
            {
                if (heartrate >= self._heartbeatZones[2])
                {
                    if (self._display == null || self._display instanceof Indi.Heartbeat == false)
                    {
                        self._display = new  Indi.Heartbeat(self);
                    }
                    found = true;
                }
                else if (stress >= stresswarninglevel)
                {
                    if (self._display == null || self._display instanceof Indi.Stress == false)
                    {
                        self._display = new  Indi.Stress(self);
                    }
                    found = true;
                }
            }

            if (found == false || self._display == null)
            {
                if (self._display == null || self._display instanceof Indi.Heartbeat == false)
                {
                    self._display = new  Indi.Heartbeat(self);
                }
            }
        }
    }
}
