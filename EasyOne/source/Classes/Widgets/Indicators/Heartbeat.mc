import Toybox.Lang;
import Widgets;
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

            private var _attentionIcon = null as Gfx.BitmapResource;

            static var HeartbeatZones = [] as Array<Number>;
            static var HeartbeatMin = 0;

            protected function Init(dc as Gfx.Dc, widget as HealthIndicator)
            {
                IndicatorBase.Init(dc, widget);
                self._textContainer = new Helper.ExtText(self._textPosX, self._textPosY, Helper.ExtText.HJUST_CENTER, Helper.ExtText.VJUST_TOP);
                self._texts = [] as Array<Helper.ExtTextPart>;
            }

            function draw(dc as Gfx.Dc, widget as HealthIndicator)
            {
                IndicatorBase.draw(dc, widget);
                var heartrate = self.getHeartrate();

                var theme = $.getTheme();

                var color = theme.IconsOff;
                var iconcolor = theme.IconsOff;
                var indicatorcolor = color;
                if (heartrate > 0)
                {
                    color = Themes.Colors.Text2;
                    if (Themes.Colors.IconsInTextColor == true)
                    {
                        iconcolor = color;
                    }
                    else
                    {
                        iconcolor = theme.HealthHeartIconColor;
                    }

                    var colors = $.getTheme().IndivatorLevel;
                    indicatorcolor = colors[0];
                    if (self.HeartbeatZones.size() > 1)
                    {
                        for (var i = 1; i < self.HeartbeatZones.size(); i++)
                        {
                            if (heartrate >= self.HeartbeatZones[i])
                            {
                                color = colors[i];
                                indicatorcolor = color;
                                iconcolor = color;
                            }                            
                        }
                    }

                    dc.setColor(iconcolor, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER);
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

                    if (heartrate >= self.HeartbeatZones[self.HeartbeatZones.size() -1])
                    {
                        widget.DrawAttentionIcon(dc, self._iconPosX, self._iconPosY);
                    }
                    else
                    {
                        widget.HideAttentionIcon();
                    }
                }
                else
                {
                    dc.setColor(color, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(self._iconPosX, self._iconPosY, HGfx.Fonts.Icons, HGfx.ICONS_HEART, Gfx.TEXT_JUSTIFY_CENTER);
                    dc.drawText(self._textPosX, self._textPosY, HGfx.Fonts.Normal, "-", Gfx.TEXT_JUSTIFY_CENTER);
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
                widget.drawIndicator(dc, amount, indicatorcolor);
            }

            public static function getHeartrate() as Number
            {
                var info = Toybox.Activity.getActivityInfo();
                if (info != null && info.currentHeartRate != null)
                {
                    return info.currentHeartRate;
                }

                return -1;
            }
        }
    }
}