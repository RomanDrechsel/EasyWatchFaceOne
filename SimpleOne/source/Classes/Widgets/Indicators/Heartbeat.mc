import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as Draw;

module Widgets 
{
    module Indicators
    {
        class Heartbeat extends IndicatorBase
        {
            private var _textContainer = null as Helper.ExtText;

            private var _heartbeatColors = [
                0x00ad15,
                0xf7fa00,
                0xfa7a00,
                0xfa0000
            ];
            private var _heartbeatZones = [];
            private var _texts = [] as Array<Helper.ExtTextPart>;
            private var _heartbeatMin = 0;

            function initialize(widget as Widgets.Heartbeat)
            {
                IndicatorBase.initialize(widget);
            }

            function setZones(zones as Array<Number>)
            {
                self._heartbeatZones = [ zones[2], zones[3], zones[4], zones[5] ];
                self._heartbeatMin = zones[0] * 0.6;
            }

            protected function Init(dc as Gfx.Dc)
            {
                IndicatorBase.Init(dc);
                self._textContainer = new Helper.ExtText(self._textPosX, self._textPosY, Helper.ExtText.HJUST_CENTER, Helper.ExtText.VJUST_CENTER);
            }

            function draw(dc as Gfx.Dc)
            {
                IndicatorBase.draw(dc);
                var heartrate = self.getHeartrate();

                var color = self._Widget._theme.IconsOff;
                var iconcolor = self._Widget._theme.IconsOff;
                var indicatorcolor = color;
                if (heartrate > 0)
                {
                    color = self._Widget._theme.MainTextColor;
                    iconcolor = color;
                    indicatorcolor = self._heartbeatColors[0];
                    if (self._Widget._heartbeatZones.size() > 1)
                    {
                        for (var i = 1; i < self._Widget._heartbeatZones.size(); i++)
                        {
                            if (heartrate >= self._Widget._heartbeatZones[i])
                            {
                                color = self._heartbeatColors[i];
                                indicatorcolor = color;
                            }
                        }
                    }
                }

                if (heartrate > 0)
                {
                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);

                    if (self._texts.size() < 2)
                    {
                        self._texts = [
                            new Helper.ExtTextPart(heartrate.toString(), color, self._Widget._Font),
                            new Helper.ExtTextPart(" bpm", color, self._Widget._Font2)
                        ];
                        self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                    }

                    self._texts[0].Text = heartrate.toString();
                    self._textContainer.draw(self._texts, dc);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, self._Widget._Icons, Draw.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, self._Widget._Font, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                var amount = 0.0;
                if (heartrate >= self._heartbeatMin)
                {
                    amount = (heartrate - self._Widget._heartbeatMin).toFloat() / (self._Widget._heartbeatZones[3] - self._Widget._heartbeatMin).toFloat();
                }
                else if (heartrate > 0)
                {
                    amount = 0.001;
                }
                self._Widget._indicatorDrawing.drawWithColor(dc, amount, indicatorcolor);
            }

            public static function getHeartrate() as Number
            {
                var info = Toybox.Activity.getActivityInfo();
                if (info.currentHeartRate != null)
                {
                    return info.currentHeartRate;
                }

                return -1;
            }
        }
    }
}