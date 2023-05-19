using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.UserProfile;
using Helper.Gfx as Draw;

module Widgets 
{
    class Heartbeat extends WidgetBase
    {
        private var _Icons = null as FontResource;
        private var _Font = null as FontResource;
        private var _Font2 = null as FontResource;

        private var _WidgetHeight = 200;
        private var _WidgetWidth = 150;

        private var _indicatorLineWidth = 4;
        private var _indicatorLineWidthBold = 6;
        private var _indicatorDotRadius = 5;
        private var _indicatorPadding = 10;
        private var _indicatorDrawing = null as Draw.DrawRoundAngle;

        private var _textContainer = null as Helper.ExtText;

        private var _iconPosX = 0;
        private var _iconPosY = 0;
        private var _textPosX = 0;
        private var _textPosY = 0;
        private var _iconColor as Number;

        private var _heartbeatColors = [
            0x00ad15,
            0xf7fa00,
            0xfa0000
        ];
        private var _heartbeatZones = [];
        private var _texts = [] as Array<Helper.ExtTextPart>;

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

            self._iconColor = self._theme.IconsOn;

            $.getView().OnWakeup.add(self.WakeUp);
        }

        function draw(dc as Gfx.Dc)
        {
            if (self._initialized == false)
            {
                self.Init(dc);
            }

            var info = Toybox.Activity.getActivityInfo();

            self.drawHeartbeat(dc, info);
        }

        private function Init(dc as Gfx.Dc)
        {
            var iconHeight = dc.getFontHeight(self._Icons);
            var fontHeight = dc.getFontHeight(self._Font);
            var centerX = self.locX + (self._WidgetWidth / 2 * 1.2);
            var centerY = self.locY + (self._WidgetHeight / 2 * 1.1);

            self._iconPosX = centerX;
            self._iconPosY = centerY - (iconHeight / 2) - 10;
            var textPosX = centerX;
            var textPosY = centerY + (fontHeight / 2) - 5;

            self._textContainer = new Helper.ExtText(textPosX, textPosY, Helper.ExtText.HJUST_CENTER, Helper.ExtText.VJUST_CENTER);

            self.WakeUp();
            self._initialized = true;
        }

        function WakeUp()
        {   
            var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
            self._heartbeatZones = [ zones[3], zones[4], zones[5] ];

            self.InitHeartbeat();
        }

        private function InitHeartbeat()
        {            
            self._iconColor = 0xff1111;
        }

        private function drawHeartbeat(dc as Gfx.Dcm, info as Toybox.Activity.Info)
        {
            var heartrate = 0;
            if (info.averageHeartRate != null)
            {
                heartrate = info.averageHeartRate;
            }
            else
            {
                var hrs = Toybox.ActivityMonitor.getHeartRateHistory(1, true).next();
                if (hrs != null && hrs.heartRate != Toybox.ActivityMonitor.INVALID_HR_SAMPLE)
                {
                    heartrate = hrs.heartRate;
                }
            }

            var color = self._theme.IconsOff;
            if (heartrate > 0)
            {
                color = self._heartbeatColors[0];
                if (self._heartbeatZones.size() > 0)
                {
                    for (var i = 0; i < self._heartbeatZones.size(); i++)
                    {
                        if (heartrate >= self._heartbeatZones[i])
                        {
                            color = self._heartbeatColors[i];
                        }
                    }
                }
            }            

            dc.setColor(self._iconColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(self._iconPosX, self._iconPosY, self._Icons, Draw.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            dc.setColor(color, Gfx.COLOR_TRANSPARENT);

            if (heartrate > 0)
            {
                if (self._texts.size() < 2)
                {
                    self._texts = [
                        new Helper.ExtTextPart(heartrate.toString(), color, self._Font),
                        new Helper.ExtTextPart(" bpm", color, self._Font2)
                    ];
                    self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                }

                self._texts[0].Text = heartrate.toString();
                self._textContainer.draw(self._texts, dc);
            }
            else
            {
                dc.drawText(self._textPosX, self._textPosY, self._Font, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }
        }
    }
}
