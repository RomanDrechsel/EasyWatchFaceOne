import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Helper.Gfx as HGfx;

module Widgets 
{
    module Indicators
    {
        class Heartbeat extends IndicatorBase
        {
            private var _textContainer = null as Helper.ExtText;
            private var _texts = [] as Array<Helper.ExtTextPart>;
            private var _heartbeatMinDisplay = 40;

            static var HeartbeatZones = [] as Array<Number>;
            static var HeartbeatMin = 0;

            function initialize(widget as Widgets.HealthIndicator)
            {
                IndicatorBase.initialize(widget);
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
                    indicatorcolor = self._Widget.IndicatorColors[0];
                    if (self.HeartbeatZones.size() > 1)
                    {
                        for (var i = 1; i < self.HeartbeatZones.size(); i++)
                        {
                            if (heartrate >= self.HeartbeatZones[i])
                            {
                                color = self._Widget.IndicatorColors[i];
                                indicatorcolor = color;
                                iconcolor = color;
                            }                            
                        }
                    }
                }

                if (heartrate > 0)
                {
                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    //dc.setColor(color, Gfx.COLOR_TRANSPARENT);

                    if (self._texts.size() < 2)
                    {
                        self._texts = [
                            new Helper.ExtTextPart(heartrate.toString(), color, HGfx.Fonts.Normal),
                            new Helper.ExtTextPart(" bpm", color, HGfx.Fonts.Small)
                        ];
                        self._texts[1].Vjust = Helper.ExtText.VJUST_BOTTOM;
                    }
                    else
                    {
                        self._texts[0].Text = heartrate.toString();
                        self._texts[0].Color = color;
                        self._texts[1].Color = color;
                    }
                    self._textContainer.draw(self._texts, dc);
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                    dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, "-", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
                }

                var amount = 0.0;
                if (heartrate >= self._heartbeatMinDisplay)
                {
                    amount = (heartrate - self.HeartbeatMin).toFloat() / (self.HeartbeatZones[3] - self.HeartbeatMin).toFloat();
                }
                else if (heartrate > 0)
                {
                    amount = 0.001;
                }
                self._Widget.IndicatorDrawing.drawWithColor(dc, amount, indicatorcolor);
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